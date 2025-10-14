# Assets Guide

## 📁 Directory Structure

```
assets/
├── images/          # Images (PNG, JPG, WebP, etc.)
├── fonts/           # Custom fonts (TTF, OTF)
├── icons/           # Icon files (PNG, SVG)
└── animations/      # Animation files (Lottie, Rive)
```

## 🖼️ Images

### Where to Put Images
Place all images in `assets/images/` directory:

```
assets/images/
├── logo.png
├── splash_background.jpg
├── placeholder.png
└── backgrounds/
    ├── home_bg.png
    └── profile_bg.png
```

### Supported Formats
- PNG (recommended for transparency)
- JPG/JPEG (recommended for photos)
- WebP (recommended for web)
- GIF
- BMP, WBMP

### How to Use

**Basic usage:**
```dart
Image.asset('assets/images/logo.png')
```

**With size:**
```dart
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

**As decoration:**
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.jpg'),
      fit: BoxFit.cover,
    ),
  ),
)
```

**Check if image exists:**
```dart
// In AssetBundle
final ByteData data = await rootBundle.load('assets/images/logo.png');
```

### Resolution-Aware Images

For different screen densities, create variants:

```
assets/images/
├── logo.png          # 1x (baseline)
├── 2.0x/
│   └── logo.png      # 2x
└── 3.0x/
    └── logo.png      # 3x
```

Flutter automatically selects the appropriate resolution.

## 🔤 Fonts

### Where to Put Fonts
Place fonts in `assets/fonts/` directory:

```
assets/fonts/
├── Roboto-Regular.ttf
├── Roboto-Bold.ttf
├── Roboto-Italic.ttf
└── CustomFont.otf
```

### Supported Formats
- TTF (TrueType Font)
- OTF (OpenType Font)

### How to Configure

**1. Add fonts to `pubspec.yaml`:**
```yaml
flutter:
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
        - asset: assets/fonts/Roboto-Italic.ttf
          style: italic
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont.otf
```

**2. Use in your app:**

**Set as default:**
```dart
MaterialApp(
  theme: ThemeData(
    fontFamily: 'Roboto',
  ),
  // ...
)
```

**Use specific font:**
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'CustomFont',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

## 🎨 Icons

### Where to Put Icons
Place custom icons in `assets/icons/` directory:

```
assets/icons/
├── custom_home.png
├── custom_search.svg
└── menu_icon.png
```

### How to Use

**PNG icons:**
```dart
Image.asset(
  'assets/icons/custom_home.png',
  width: 24,
  height: 24,
)
```

**SVG icons (requires flutter_svg package):**
```dart
// Add to pubspec.yaml: flutter_svg: ^2.0.0
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/icons/custom_search.svg',
  width: 24,
  height: 24,
  color: Colors.blue,
)
```

## 🎬 Animations

### Where to Put Animations
Place animations in `assets/animations/` directory:

```
assets/animations/
├── loading.json        # Lottie
├── success.json        # Lottie
└── onboarding.riv      # Rive
```

### Lottie Animations

**1. Add package:**
```yaml
dependencies:
  lottie: ^3.0.0
```

**2. Use animation:**
```dart
import 'package:lottie/lottie.dart';

Lottie.asset(
  'assets/animations/loading.json',
  width: 200,
  height: 200,
  repeat: true,
)
```

**Download animations from:** https://lottiefiles.com/

### Rive Animations

**1. Add package:**
```yaml
dependencies:
  rive: ^0.13.0
```

**2. Use animation:**
```dart
import 'package:rive/rive.dart';

RiveAnimation.asset(
  'assets/animations/onboarding.riv',
)
```

**Create animations at:** https://rive.app/

## 📝 Best Practices

### 1. Organization

**Group by feature:**
```
assets/images/
├── auth/
│   ├── login_bg.png
│   └── signup_bg.png
├── home/
│   ├── hero_image.png
│   └── banner.jpg
└── shared/
    ├── logo.png
    └── placeholder.png
```

**Or by type:**
```
assets/images/
├── backgrounds/
├── logos/
├── icons/
└── illustrations/
```

### 2. Naming Convention

Use lowercase with underscores:
- ✅ `user_profile.png`
- ✅ `background_home.jpg`
- ❌ `UserProfile.png`
- ❌ `background-home.jpg`

### 3. Image Optimization

**Before adding images:**
- Compress images (use TinyPNG, ImageOptim)
- Use WebP for web builds
- Use appropriate resolution (don't use 4K images for icons)
- Remove EXIF data

**Tools:**
- [TinyPNG](https://tinypng.com/) - PNG/JPG compression
- [Squoosh](https://squoosh.app/) - Image optimization
- [ImageOptim](https://imageoptim.com/) - Mac app for optimization

### 4. File Size Guidelines

| Type | Recommended Size |
|------|------------------|
| Icons | < 10 KB |
| Small images | < 50 KB |
| Medium images | < 200 KB |
| Large images | < 500 KB |
| Background | < 200 KB (compressed) |

### 5. Resolution Guidelines

| Use Case | Size |
|----------|------|
| App icon | 1024x1024 |
| Thumbnails | 150x150 |
| Profile pictures | 200x200 |
| Banner images | 1200x400 |
| Background images | 1920x1080 |

## 🔧 Advanced Usage

### Load Assets Programmatically

```dart
import 'package:flutter/services.dart' show rootBundle;

// Load as string
String data = await rootBundle.loadString('assets/data/config.json');

// Load as bytes
ByteData bytes = await rootBundle.load('assets/images/logo.png');

// Load multiple assets
List<String> imagePaths = [
  'assets/images/img1.png',
  'assets/images/img2.png',
];
```

### Precache Images

```dart
// Precache single image
await precacheImage(
  AssetImage('assets/images/logo.png'),
  context,
);

// Precache multiple images
Future<void> precacheImages(BuildContext context) async {
  await Future.wait([
    precacheImage(AssetImage('assets/images/img1.png'), context),
    precacheImage(AssetImage('assets/images/img2.png'), context),
  ]);
}
```

### Create Asset Constants

```dart
// lib/core/constants/asset_constants.dart
class AssetConstants {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String splash = 'assets/images/splash_background.jpg';
  static const String placeholder = 'assets/images/placeholder.png';
  
  // Icons
  static const String homeIcon = 'assets/icons/home.png';
  static const String searchIcon = 'assets/icons/search.png';
  
  // Animations
  static const String loading = 'assets/animations/loading.json';
  static const String success = 'assets/animations/success.json';
  
  // Fonts
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'CustomFont';
}

// Usage
Image.asset(AssetConstants.logo)
```

## 🐛 Troubleshooting

### Image Not Showing?

1. **Check pubspec.yaml** - Make sure the asset path is declared
2. **Run `flutter pub get`** - Reload assets
3. **Restart app** - Hot reload may not work for new assets
4. **Check file path** - Paths are case-sensitive
5. **Check file exists** - Make sure file is actually in the directory

### Font Not Applying?

1. **Check pubspec.yaml** - Verify font family name
2. **Match family name** - Use exact same name in TextStyle
3. **Restart app** - Hot reload doesn't work for fonts
4. **Check font file** - Make sure TTF/OTF file is valid

### Common Errors

**Error: Unable to load asset**
```
Solution: Check the path in pubspec.yaml matches the actual file location
```

**Error: Asset not found**
```
Solution: Run `flutter clean` then `flutter pub get`
```

**Error: FontFamily not found**
```
Solution: Make sure family name in pubspec.yaml matches what you use in code
```

## 📋 Checklist for Adding Assets

- [ ] Create/organize files in appropriate `assets/` subdirectory
- [ ] Declare assets in `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Test assets in your app
- [ ] Optimize images (compress, resize)
- [ ] Create resolution variants for images (1x, 2x, 3x)
- [ ] Add asset constants for easy reference
- [ ] Document any special assets in your team docs

## 🔗 Useful Resources

- [Flutter Assets Documentation](https://docs.flutter.dev/development/ui/assets-and-images)
- [Flutter Custom Fonts](https://docs.flutter.dev/cookbook/design/fonts)
- [Image Optimization Guide](https://docs.flutter.dev/perf/rendering-performance)
- [Lottie Files](https://lottiefiles.com/)
- [Rive Animations](https://rive.app/)

---

**Your assets are configured and ready to use!** 🎉

