# Quick Start - Assets

## ✅ What's Been Set Up

Your project now has a complete assets structure configured and ready to use!

```
assets/
├── images/         ← Put PNG, JPG, WebP here
├── fonts/          ← Put TTF, OTF here
├── icons/          ← Put custom icons here
└── animations/     ← Put Lottie/Rive files here
```

All asset directories are **already declared in pubspec.yaml** and ready to use! ✅

## 🚀 Quick Usage

### Images

**1. Add your image:**
```bash
# Copy your image to:
assets/images/logo.png
```

**2. Use it:**
```dart
Image.asset('assets/images/logo.png')

// With size
Image.asset(
  'assets/images/logo.png',
  width: 100,
  height: 100,
)

// As background
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.jpg'),
      fit: BoxFit.cover,
    ),
  ),
)
```

### Custom Fonts

**1. Add font files:**
```bash
# Copy fonts to:
assets/fonts/MyFont-Regular.ttf
assets/fonts/MyFont-Bold.ttf
```

**2. Declare in pubspec.yaml:**
```yaml
flutter:
  fonts:
    - family: MyFont
      fonts:
        - asset: assets/fonts/MyFont-Regular.ttf
        - asset: assets/fonts/MyFont-Bold.ttf
          weight: 700
```

**3. Run:**
```bash
flutter pub get
```

**4. Use it:**
```dart
Text(
  'Hello World',
  style: TextStyle(fontFamily: 'MyFont'),
)

// Or set as default in theme
MaterialApp(
  theme: ThemeData(fontFamily: 'MyFont'),
)
```

### Icons

**1. Add icon:**
```bash
# Copy to:
assets/icons/custom_icon.png
```

**2. Use it:**
```dart
Image.asset('assets/icons/custom_icon.png', width: 24)
```

### Animations (Lottie)

**1. Download from:** https://lottiefiles.com/

**2. Add to:**
```bash
assets/animations/loading.json
```

**3. Add package:**
```yaml
dependencies:
  lottie: ^3.0.0
```

**4. Use it:**
```dart
import 'package:lottie/lottie.dart';

Lottie.asset('assets/animations/loading.json')
```

## 📁 Asset Constants (Recommended)

Use the pre-created constants file for better code organization:

**1. Edit:** `lib/core/constants/asset_constants.dart`

```dart
class AssetConstants {
  // Add your assets here
  static const String logo = 'assets/images/logo.png';
  static const String homeIcon = 'assets/icons/home.png';
}
```

**2. Use in your app:**
```dart
Image.asset(AssetConstants.logo)
```

**Benefits:**
- ✅ No typos
- ✅ Auto-complete in IDE
- ✅ Easy refactoring
- ✅ Single source of truth

## 🎯 Example: Adding a Logo

**Step 1:** Copy logo to `assets/images/logo.png`

**Step 2:** Add to constants:
```dart
// lib/core/constants/asset_constants.dart
static const String logo = 'assets/images/logo.png';
```

**Step 3:** Use in splash screen:
```dart
// lib/features/splash/splash_page.dart
Image.asset(
  AssetConstants.logo,
  width: 200,
  height: 200,
)
```

## 📋 Checklist

When adding new assets:

- [ ] Place file in correct `assets/` subdirectory
- [ ] For **images/icons/animations**: Already configured in pubspec.yaml ✅
- [ ] For **fonts**: Add declaration to pubspec.yaml fonts section
- [ ] Run `flutter pub get` (only needed after pubspec.yaml changes)
- [ ] Add to `AssetConstants` class (recommended)
- [ ] Restart app (hot reload may not work for new assets)

## 🔧 Already Configured

In `pubspec.yaml`:
```yaml
assets:
  - assets/images/
  - assets/icons/
  - assets/animations/
```

This means ALL files in these directories are automatically included! 🎉

## ⚠️ Common Issues

**Image not showing?**
- Check file path is correct (case-sensitive)
- Restart app (not just hot reload)
- Make sure file is actually in the directory

**Font not working?**
- Declare in pubspec.yaml
- Run `flutter pub get`
- Restart app completely
- Check family name matches exactly

## 📚 Full Documentation

For complete details, see:
- **ASSETS_GUIDE.md** - Complete guide with examples
- **assets/README.md** - Quick reference in assets folder

## 💡 Tips

1. **Optimize images** before adding (use TinyPNG.com)
2. **Use meaningful names** (logo.png, not img1.png)
3. **Organize by feature** if you have many assets
4. **Create resolution variants** (@2x, @3x) for crisp images
5. **Keep file sizes small** (< 500KB for most images)

---

**You're all set! Start adding assets to your app!** 🎨

