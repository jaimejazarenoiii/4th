# Dio HTTP Client Setup - Quick Reference

## ✅ What Was Added

### 1. Dependencies
- **dio** (v5.4.0): HTTP client
- **pretty_dio_logger** (v1.3.1): Request/response logging

### 2. Files Created

```
lib/core/network/
├── api_constants.dart          # API configuration
├── dio_client.dart             # HTTP client wrapper
├── network_info.dart           # Network connectivity checker
└── README.md                   # Detailed documentation

lib/features/inventory/data/datasources/
└── inventory_remote_data_source.dart  # Example API integration
```

### 3. Dependency Injection

DioClient is registered in `injection_container.dart` and ready to use:
```dart
sl.registerLazySingleton(() => DioClient());
sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
```

## 🚀 Quick Start

### Configuration

**Base URL**: `http://localhost:3000/api/v1/`

To change it, edit `lib/core/network/api_constants.dart`:
```dart
static const String baseUrl = 'http://localhost:3000/api/v1/';
```

### Making API Calls

**1. Get the client:**
```dart
import 'package:fourth/core/di/injection_container.dart' as di;

final dioClient = di.sl<DioClient>();
```

**2. Make requests:**

```dart
// GET
final response = await dioClient.get('spaces');

// POST
final response = await dioClient.post(
  'spaces',
  data: {'name': 'My Space', 'description': 'Description'},
);

// PUT
final response = await dioClient.put(
  'spaces/123',
  data: {'name': 'Updated'},
);

// DELETE
final response = await dioClient.delete('spaces/123');
```

### Error Handling

```dart
try {
  final response = await dioClient.get('spaces');
  print(response.data);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    print('Connection timeout');
  } else if (e.type == DioExceptionType.badResponse) {
    print('Bad response: ${e.response?.statusCode}');
  } else {
    print('Error: ${e.message}');
  }
}
```

### Authentication

```dart
// Set token
dioClient.setAuthToken('your_jwt_token');

// Clear token
dioClient.clearAuthToken();
```

## 📋 API Endpoints

Current endpoints defined in `ApiConstants`:

| Endpoint | URL | Purpose |
|----------|-----|---------|
| spaces | `/spaces` | CRUD operations for spaces |
| storages | `/storages` | CRUD operations for storages |
| items | `/items` | CRUD operations for items |

**Example URLs:**
- GET all spaces: `http://localhost:3000/api/v1/spaces`
- GET space by ID: `http://localhost:3000/api/v1/spaces/123`
- POST new space: `http://localhost:3000/api/v1/spaces`

## 🔄 Switching from Local to Remote Storage

### Current Setup
The app uses **local storage** (SharedPreferences) by default.

### To Use API Instead

**Step 1:** The remote data source is already created! See:
- `lib/features/inventory/data/datasources/inventory_remote_data_source.dart`

**Step 2:** Register it in `injection_container.dart`:

```dart
// Add this to init()
sl.registerLazySingleton<InventoryRemoteDataSource>(
  () => InventoryRemoteDataSourceImpl(dioClient: sl()),
);
```

**Step 3:** Update repository to use remote source:

```dart
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SpaceEntity>>> getSpaces() async {
    if (await networkInfo.isConnected) {
      try {
        final spaces = await remoteDataSource.getSpaces();
        return Right(spaces);
      } on DioException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
```

## 🧪 Testing API

### Using curl

```bash
# Test GET
curl http://localhost:3000/api/v1/spaces

# Test POST
curl -X POST http://localhost:3000/api/v1/spaces \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Space", "description": "Test"}'
```

### Using the App

1. Make sure your backend is running at `http://localhost:3000`
2. Switch to remote data source (follow steps above)
3. Run the app: `flutter run`
4. Check logs for API requests (pretty_dio_logger will show all requests)

## 📝 Logging

In **debug mode**, all HTTP requests/responses are automatically logged:

```
┌──────────────────────────────────────────────────────────────
│ REQUEST  ⚡
├──────────────────────────────────────────────────────────────
│ [POST] http://localhost:3000/api/v1/spaces
│ Headers:
│  • Content-Type: application/json
│ Body:
│  • {"name": "My Space", "description": "Test"}
├──────────────────────────────────────────────────────────────
│ RESPONSE ✅
├──────────────────────────────────────────────────────────────
│ [200] http://localhost:3000/api/v1/spaces
│ Response:
│  • {"id": "123", "name": "My Space", ...}
└──────────────────────────────────────────────────────────────
```

## ⚙️ Advanced Configuration

### Change Base URL Dynamically

```dart
dioClient.updateBaseUrl('https://api.production.com/api/v1/');
```

### Add Custom Headers

```dart
dioClient.dio.options.headers['X-Custom-Header'] = 'value';
```

### Cancel Request

```dart
final cancelToken = CancelToken();

// Start request
dioClient.get('spaces', cancelToken: cancelToken);

// Cancel it
cancelToken.cancel('Cancelled by user');
```

### Upload Progress

```dart
await dioClient.post(
  'upload',
  data: formData,
  onSendProgress: (sent, total) {
    print('Upload: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

## 🎯 Next Steps

1. **Set up your backend** at `http://localhost:3000/api/v1/`
2. **Test endpoints** using curl or Postman
3. **Switch to remote data source** when backend is ready
4. **Implement offline-first** by combining local + remote storage
5. **Add authentication** if your API requires it

## 📚 Full Documentation

For complete details, see:
- `lib/core/network/README.md` - Comprehensive Dio documentation
- `lib/features/inventory/data/datasources/inventory_remote_data_source.dart` - Example implementation

## 🆘 Troubleshooting

**Connection refused?**
- Make sure backend is running
- Check if URL is correct
- Try `http://127.0.0.1:3000` instead of `localhost`

**Timeout errors?**
- Increase timeout in `api_constants.dart`
- Check network connection
- Verify backend is responding

**CORS errors (web)?**
- Configure CORS on your backend
- Add appropriate headers

---

✅ **Dio is now configured and ready to use!**

