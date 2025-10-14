# HTTP Client (Dio) Documentation

## Overview

This app uses **Dio** as the HTTP client for making API requests. The client is configured with interceptors, logging, and error handling.

## Configuration

### Base URL
Current base URL: `http://localhost:3000/api/v1/`

To change the base URL, modify `ApiConstants.baseUrl` in `lib/core/network/api_constants.dart`

### Timeouts
- Connect Timeout: 30 seconds
- Receive Timeout: 30 seconds
- Send Timeout: 30 seconds

## Using the Dio Client

### 1. Accessing the Client

The DioClient is registered in the dependency injection container and can be accessed via:

```dart
import 'package:fourth/core/di/injection_container.dart' as di;

final dioClient = di.sl<DioClient>();
```

### 2. Making HTTP Requests

#### GET Request
```dart
try {
  final response = await dioClient.get('spaces');
  print(response.data);
} on DioException catch (e) {
  // Handle error
  print('Error: ${e.message}');
}
```

#### POST Request
```dart
try {
  final response = await dioClient.post(
    'spaces',
    data: {
      'name': 'My Space',
      'description': 'A new space',
    },
  );
  print(response.data);
} on DioException catch (e) {
  print('Error: ${e.message}');
}
```

#### PUT Request
```dart
try {
  final response = await dioClient.put(
    'spaces/123',
    data: {
      'name': 'Updated Space',
      'description': 'Updated description',
    },
  );
  print(response.data);
} on DioException catch (e) {
  print('Error: ${e.message}');
}
```

#### DELETE Request
```dart
try {
  final response = await dioClient.delete('spaces/123');
  print('Deleted successfully');
} on DioException catch (e) {
  print('Error: ${e.message}');
}
```

### 3. Query Parameters

```dart
final response = await dioClient.get(
  'spaces',
  queryParameters: {
    'page': 1,
    'limit': 10,
    'search': 'office',
  },
);
```

### 4. Authentication

#### Set Auth Token
```dart
dioClient.setAuthToken('your_token_here');
```

#### Clear Auth Token
```dart
dioClient.clearAuthToken();
```

## Remote Data Source Example

See `lib/features/inventory/data/datasources/inventory_remote_data_source.dart` for a complete example of using Dio in a data source.

Example usage:
```dart
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final DioClient dioClient;

  InventoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SpaceModel>> getSpaces() async {
    try {
      final response = await dioClient.get(ApiConstants.spaces);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => SpaceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load spaces');
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
```

## Switching from Local to Remote Data Source

### Current Setup (Local Storage)
The app currently uses `InventoryLocalDataSource` which stores data in SharedPreferences.

### To Use Remote API

1. **Register Remote Data Source** in `injection_container.dart`:

```dart
// Comment out local data source
// sl.registerLazySingleton<InventoryLocalDataSource>(
//   () => InventoryLocalDataSourceImpl(
//     sharedPreferences: sl(),
//     uuid: sl(),
//   ),
// );

// Add remote data source
sl.registerLazySingleton<InventoryRemoteDataSource>(
  () => InventoryRemoteDataSourceImpl(
    dioClient: sl(),
  ),
);
```

2. **Update Repository Implementation** to use remote data source:

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

3. **Update Dependency Injection**:

```dart
sl.registerLazySingleton<InventoryRepository>(
  () => InventoryRepositoryImpl(
    remoteDataSource: sl(),
    networkInfo: sl(),
  ),
);
```

## Error Handling

### DioException Types

```dart
try {
  final response = await dioClient.get('spaces');
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      print('Connection timeout');
      break;
    case DioExceptionType.sendTimeout:
      print('Send timeout');
      break;
    case DioExceptionType.receiveTimeout:
      print('Receive timeout');
      break;
    case DioExceptionType.badResponse:
      print('Bad response: ${e.response?.statusCode}');
      break;
    case DioExceptionType.cancel:
      print('Request cancelled');
      break;
    case DioExceptionType.connectionError:
      print('Connection error');
      break;
    default:
      print('Unknown error: ${e.message}');
  }
}
```

## Logging

The app uses `PrettyDioLogger` in debug mode to log:
- Request headers
- Request body
- Response body
- Errors

Logs will appear in your console when making API requests.

## Testing API Endpoints

### Using curl

```bash
# GET spaces
curl http://localhost:3000/api/v1/spaces

# POST space
curl -X POST http://localhost:3000/api/v1/spaces \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Space", "description": "A test space"}'

# PUT space
curl -X PUT http://localhost:3000/api/v1/spaces/123 \
  -H "Content-Type: application/json" \
  -d '{"name": "Updated Space", "description": "Updated"}'

# DELETE space
curl -X DELETE http://localhost:3000/api/v1/spaces/123
```

### Using Postman
Import the following collection base URL: `http://localhost:3000/api/v1/`

## API Endpoints

Current endpoints defined in `ApiConstants`:

| Endpoint | Description |
|----------|-------------|
| `/spaces` | Spaces CRUD |
| `/storages` | Storages CRUD |
| `/items` | Items CRUD |

## Best Practices

1. **Always handle DioException** in data sources
2. **Use try-catch** for all network calls
3. **Return Either<Failure, Success>** from repositories
4. **Check network connectivity** before making requests
5. **Use const for API endpoints** in ApiConstants
6. **Log appropriately** (only in debug mode)
7. **Set timeouts** to prevent hanging requests
8. **Use cancellation tokens** for long-running requests

## Environment Configuration

To use different URLs for different environments:

```dart
class ApiConstants {
  static String get baseUrl {
    const environment = String.fromEnvironment('ENV', defaultValue: 'dev');
    switch (environment) {
      case 'prod':
        return 'https://api.production.com/api/v1/';
      case 'staging':
        return 'https://api.staging.com/api/v1/';
      default:
        return 'http://localhost:3000/api/v1/';
    }
  }
}
```

Then run with:
```bash
flutter run --dart-define=ENV=prod
```

## Next Steps

1. Set up your backend API at `http://localhost:3000/api/v1/`
2. Test API endpoints using the remote data source
3. Implement error handling in the UI
4. Add retry logic for failed requests
5. Implement caching strategy
6. Add authentication if needed

