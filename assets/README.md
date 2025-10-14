# Assets Directory

This directory contains all static assets used in the 4th app.

## Structure

```
assets/
├── images/       # PNG, JPG, WebP images
├── fonts/        # TTF, OTF custom fonts
├── icons/        # Custom icons (PNG, SVG)
└── animations/   # Lottie (JSON), Rive files
```

## Quick Reference

### Adding Images

1. Place image in `assets/images/`
2. Already declared in `pubspec.yaml` ✅
3. Use in code:
```dart
Image.asset('assets/images/your_image.png')
```

### Adding Fonts

1. Place font files in `assets/fonts/`
2. Declare in `pubspec.yaml`:
```yaml
fonts:
  - family: YourFont
    fonts:
      - asset: assets/fonts/YourFont-Regular.ttf
      - asset: assets/fonts/YourFont-Bold.ttf
        weight: 700
```
3. Use in code:
```dart
Text('Hello', style: TextStyle(fontFamily: 'YourFont'))
```

### Adding Icons

1. Place in `assets/icons/`
2. Already declared in `pubspec.yaml` ✅
3. Use: `Image.asset('assets/icons/your_icon.png')`

### Adding Animations

1. Place in `assets/animations/`
2. Already declared in `pubspec.yaml` ✅
3. For Lottie: Add `lottie: ^3.0.0` to dependencies
4. Use: `Lottie.asset('assets/animations/your_animation.json')`

## Best Practices

- ✅ Use lowercase_with_underscores for file names
- ✅ Optimize images before adding (compress them)
- ✅ Use appropriate formats (PNG for transparency, JPG for photos)
- ✅ Create @2x and @3x variants for images if needed
- ✅ Keep file sizes reasonable (< 500KB for images)

## Asset Constants

Use `AssetConstants` class for better maintainability:

```dart
// lib/core/constants/asset_constants.dart
static const String logo = 'assets/images/logo.png';

// Usage
Image.asset(AssetConstants.logo)
```

## More Info

See `ASSETS_GUIDE.md` in the project root for complete documentation.

