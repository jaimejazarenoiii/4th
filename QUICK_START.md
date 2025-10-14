# Quick Start Guide - 4th App

## 🚀 What You Have

A beautiful Flutter inventory tracking app with:
- ✅ **Clean Architecture** with BLoC pattern
- ✅ **Animated Splash Screen** with logo
- ✅ **Welcome Screen** with sign in/sign up
- ✅ **Black & White Color Scheme** (#D2D2D2 grey)
- ✅ **Outfit Font** from Google Fonts
- ✅ **Navigation System** with named routes
- ✅ **Dio HTTP Client** configured for localhost:3000/api/v1/
- ✅ **Dependency Injection** with GetIt

## 🎬 App Flow

```
1. Splash Screen (3s auto-transition)
   - Animated logo
   - App name "4th"
   - Tagline "Track what matters"
   
   ↓

2. Welcome Screen
   - Pantry illustration
   - "Your Things, Perfectly Organized"
   - Sign in / Sign up buttons
   
   ↓

3. Spaces Page (Main App)
   - Manage spaces
   - Navigate to storages
   - Navigate to items
```

## 🏃 Run the App

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Or for web
flutter run -d chrome
```

## 🎨 Design System

### Colors
- **Primary**: Black (#000000)
- **Background**: White (#FFFFFF)
- **Secondary**: Grey (#D2D2D2)

### Typography
- **Font**: Outfit (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700, 800, 900

### Components
- **Buttons**: Black & white with 4px border radius
- **Cards**: White with 12px border radius, 1px elevation
- **App Bars**: White background, black text

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart       # Black, white, grey colors
│   │   └── asset_constants.dart  # Asset paths
│   ├── di/
│   │   └── injection_container.dart  # GetIt setup
│   ├── navigation/
│   │   ├── app_routes.dart       # Route constants
│   │   ├── route_generator.dart  # Route logic
│   │   └── navigation_service.dart
│   └── network/
│       └── dio_client.dart       # HTTP client
├── features/
│   ├── splash/
│   │   └── splash_page.dart      # Logo splash screen
│   ├── welcome/
│   │   └── welcome_page.dart     # Welcome screen
│   └── inventory/
│       ├── domain/               # Entities, repositories, use cases
│       ├── data/                 # Models, data sources
│       └── presentation/         # BLoC, pages
└── main.dart

assets/
├── images/
│   ├── logo.png                  # App logo (for splash)
│   └── splash_image.png          # Welcome illustration
├── icons/
├── fonts/
└── animations/
```

## 🎯 Key Files

### App Entry Point
- `lib/main.dart` - App initialization, theme, routing

### Screens
- `lib/features/splash/splash_page.dart` - Animated splash screen
- `lib/features/welcome/welcome_page.dart` - Welcome with buttons
- `lib/features/inventory/presentation/pages/spaces_page.dart` - Main app

### Configuration
- `lib/core/constants/app_colors.dart` - Color constants
- `lib/core/constants/asset_constants.dart` - Asset paths
- `lib/core/navigation/app_routes.dart` - Route names
- `lib/core/di/injection_container.dart` - Dependencies

### Network
- `lib/core/network/dio_client.dart` - HTTP client
- `lib/core/network/api_constants.dart` - API base URL

## 📚 Documentation

Detailed guides available:
- `SPLASH_WELCOME_FLOW.md` - Splash and welcome screens
- `COLOR_SCHEME_GUIDE.md` - Color usage
- `GOOGLE_FONTS_SETUP.md` - Font implementation
- `NAVIGATION_GUIDE.md` - Navigation system
- `ASSETS_GUIDE.md` - Asset management
- `DIO_SETUP.md` - HTTP client usage

## 🔧 Common Tasks

### Add a New Color
```dart
// lib/core/constants/app_colors.dart
static const Color yourColor = Color(0xFFHEXCODE);
```

### Add a New Route
```dart
// 1. Add route constant
// lib/core/navigation/app_routes.dart
static const String yourRoute = '/your-route';

// 2. Add route case
// lib/core/navigation/route_generator.dart
case AppRoutes.yourRoute:
  return MaterialPageRoute(builder: (_) => YourPage());
```

### Navigate to a Page
```dart
// From anywhere in the app
NavigationService.navigateTo(AppRoutes.spaces);
NavigationService.replaceWith(AppRoutes.welcome);
NavigationService.goBack();
```

### Use App Colors
```dart
Container(
  color: AppColors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.black),
  ),
)
```

### Use Assets
```dart
// Images
Image.asset(AssetConstants.logo)
Image.asset(AssetConstants.splashImage)

// In decorations
decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage(AssetConstants.logo),
  ),
)
```

### Use Google Fonts
```dart
Text(
  'Hello',
  style: GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  ),
)
```

## 🌐 Network Configuration

**Base URL**: `http://localhost:3000/api/v1/`

### Make API Calls
```dart
// Get instance
final dio = sl<DioClient>();

// GET request
final response = await dio.get('/endpoint');

// POST request
final response = await dio.post('/endpoint', data: {...});
```

## ✅ Checklist

Before deploying:
- [ ] Replace logo.png with your actual logo
- [ ] Update API base URL if needed
- [ ] Customize colors if desired
- [ ] Add authentication logic to sign in/sign up
- [ ] Test on multiple devices
- [ ] Update app name and description in pubspec.yaml
- [ ] Add app icon
- [ ] Configure Firebase (if using)

## 🎨 Customization

### Change Splash Duration
```dart
// lib/features/splash/splash_page.dart, line ~126
await Future.delayed(const Duration(milliseconds: 1500));
```

### Change App Name Display
```dart
// lib/features/splash/splash_page.dart, line ~215
Text('4th', ...)  // Change this
```

### Change Tagline
```dart
// lib/features/splash/splash_page.dart, line ~229
Text('Track what matters', ...)  // Change this
```

### Change Welcome Title
```dart
// lib/features/welcome/welcome_page.dart, line ~92
Text('Your Things,\nPerfectly Organized.', ...)
```

## 🐛 Troubleshooting

### Assets not loading?
```bash
flutter clean
flutter pub get
flutter run
```

### Fonts not working?
- Check internet connection (first load)
- Fonts are cached after first download

### Navigation not working?
- Ensure NavigationService.navigatorKey is set in MaterialApp
- Check route names match exactly

### Colors not applying?
- Import app_colors.dart
- Use AppColors.black instead of Colors.black

## 📱 Run Commands

```bash
# Development
flutter run

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release

# Web
flutter build web

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean project
flutter clean
```

## 🎯 Next Steps

1. **Add Authentication**
   - Implement sign in logic
   - Implement sign up logic
   - Create auth pages

2. **Connect to Backend**
   - Update API endpoints
   - Implement remote data sources
   - Handle authentication tokens

3. **Enhance UI**
   - Add more screens
   - Implement search
   - Add filters and sorting

4. **Testing**
   - Write unit tests
   - Write widget tests
   - Write integration tests

---

**You're all set!** 🚀

Run `flutter run` to see your beautiful app in action!

For detailed information, check the specific guide files in the project root.
