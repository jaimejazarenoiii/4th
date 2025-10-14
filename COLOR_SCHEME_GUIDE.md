# Color Scheme Guide

## ✅ Color Palette Applied

Your app now uses a **minimal black and white color scheme** with your custom grey accent:

### 🎨 Primary Colors

- **Black**: `#000000` - Primary text, buttons, borders
- **White**: `#FFFFFF` - Backgrounds, card surfaces
- **Grey**: `#D2D2D2` - Secondary elements, dividers, subtle accents

## 📱 Implementation

### Global Theme (main.dart)

```dart
colorScheme: const ColorScheme.light(
  primary: Colors.black,           // Main brand color
  onPrimary: Colors.white,         // Text on black
  secondary: Color(0xFFD2D2D2),    // Your custom grey
  onSecondary: Colors.black,       // Text on grey
  surface: Colors.white,           // Card backgrounds
  onSurface: Colors.black,         // Text on white
  error: Colors.red,               // Error states
  onError: Colors.white,           // Text on error
),
```

### App Colors Constants

```dart
// lib/core/constants/app_colors.dart
class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFD2D2D2);
  
  // Semantic colors
  static const Color primary = black;
  static const Color onPrimary = white;
  static const Color secondary = grey;
  static const Color surface = white;
  static const Color onSurface = black;
}
```

## 🎯 Usage Examples

### Text Colors

```dart
// Primary text (black)
Text(
  'Main heading',
  style: TextStyle(color: AppColors.black),
)

// Secondary text (grey for subtle elements)
Text(
  'Subtitle or caption',
  style: TextStyle(color: AppColors.grey),
)

// Text on dark backgrounds
Text(
  'White text',
  style: TextStyle(color: AppColors.white),
)
```

### Background Colors

```dart
// Main background
Container(
  color: AppColors.white,
  child: Text('Content'),
)

// Card backgrounds
Card(
  color: AppColors.white,
  child: ListTile(title: Text('Card content')),
)

// Subtle background areas
Container(
  color: AppColors.grey,
  child: Text('Subtle area'),
)
```

### Button Colors

```dart
// Primary button (black)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.black,
    foregroundColor: AppColors.white,
  ),
  onPressed: () {},
  child: Text('Primary Action'),
)

// Secondary button (outlined)
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.black),
    foregroundColor: AppColors.black,
  ),
  onPressed: () {},
  child: Text('Secondary Action'),
)

// Subtle button (grey)
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.grey,
  ),
  onPressed: () {},
  child: Text('Subtle Action'),
)
```

### Border and Divider Colors

```dart
// Main borders
Container(
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.black),
  ),
  child: Text('Bordered content'),
)

// Subtle dividers
Divider(color: AppColors.grey, thickness: 1),

// Card borders
Card(
  shape: RoundedRectangleBorder(
    side: BorderSide(color: AppColors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  child: ListTile(title: Text('Card with border')),
)
```

## 🎨 Component-Specific Colors

### AppBar

```dart
AppBar(
  backgroundColor: AppColors.white,
  foregroundColor: AppColors.black,
  elevation: 2,
  title: Text('Title'),
)
```

### Cards

```dart
Card(
  color: AppColors.white,
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    title: Text('Card Title', style: TextStyle(color: AppColors.black)),
    subtitle: Text('Subtitle', style: TextStyle(color: AppColors.grey)),
  ),
)
```

### Lists

```dart
ListTile(
  title: Text('List Item', style: TextStyle(color: AppColors.black)),
  subtitle: Text('Description', style: TextStyle(color: AppColors.grey)),
  trailing: Icon(Icons.arrow_forward, color: AppColors.grey),
)
```

## 🎯 Splash Screen Colors

Your splash screen now uses:

```dart
// Background
backgroundColor: AppColors.white

// Title text
color: AppColors.black

// Subtitle text  
color: AppColors.black

// Sign in button (outlined)
side: BorderSide(color: AppColors.black)
color: AppColors.black

// Sign up button (filled)
backgroundColor: AppColors.black
color: AppColors.white
```

## 🔧 Theme Integration

### Using Theme Colors

```dart
// Access colors through theme
Text(
  'Themed text',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
  ),
)

Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text('Themed background'),
)
```

### Custom Color Extensions

```dart
// Add to app_colors.dart if needed
extension ColorExtensions on Color {
  static Color get lightGrey => const Color(0xFFF5F5F5);
  static Color get darkGrey => const Color(0xFF808080);
}
```

## 📱 Material Design Integration

### Color Scheme Mapping

```dart
// Your colors map to Material Design as follows:
primary: AppColors.black        // Material primary
secondary: AppColors.grey       // Material secondary  
surface: AppColors.white        // Material surface
onPrimary: AppColors.white      // Material onPrimary
onSecondary: AppColors.black    // Material onSecondary
onSurface: AppColors.black      // Material onSurface
```

### Automatic Theming

```dart
// These automatically use your color scheme:
AppBar()                        // Uses primary/onPrimary
FloatingActionButton()          // Uses primary/onPrimary
ElevatedButton()               // Uses primary/onPrimary
Card()                         // Uses surface
TextField()                    // Uses onSurface
```

## 🎨 Design Principles

### Contrast Guidelines

- **Black on White**: Perfect contrast for primary text
- **Black on Grey**: Good contrast for secondary text
- **White on Black**: Perfect contrast for buttons and accents

### Hierarchy

```dart
// Text hierarchy using your colors
Text('Primary Heading', style: TextStyle(color: AppColors.black, fontSize: 24))
Text('Secondary Heading', style: TextStyle(color: AppColors.black, fontSize: 18))
Text('Body Text', style: TextStyle(color: AppColors.black, fontSize: 16))
Text('Caption', style: TextStyle(color: AppColors.grey, fontSize: 14))
```

### Interactive States

```dart
// Button states
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.black,        // Normal
    foregroundColor: AppColors.white,        // Normal
    // Flutter handles hover, pressed, disabled states automatically
  ),
  onPressed: () {},
  child: Text('Button'),
)
```

## 🚀 Best Practices

### 1. Consistency

```dart
// ✅ Good - Use constants
Text('Title', style: TextStyle(color: AppColors.black))

// ❌ Avoid - Hard-coded colors
Text('Title', style: TextStyle(color: Color(0xFF000000)))
```

### 2. Semantic Usage

```dart
// ✅ Good - Semantic meaning
Container(
  color: AppColors.surface,  // Clear intent
  child: Text('Content'),
)

// ❌ Avoid - Direct color usage without context
Container(
  color: AppColors.white,    // Less clear intent
  child: Text('Content'),
)
```

### 3. Theme Integration

```dart
// ✅ Good - Theme-aware
Text(
  'Content',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
  ),
)

// ✅ Also good - Direct constant usage
Text(
  'Content', 
  style: TextStyle(color: AppColors.black),
)
```

## 📋 Color Checklist

- ✅ **Black (#000000)** - Primary text, buttons, borders
- ✅ **White (#FFFFFF)** - Backgrounds, card surfaces  
- ✅ **Grey (#D2D2D2)** - Secondary elements, dividers
- ✅ **Theme integration** - All colors work with Material Design
- ✅ **Splash screen** - Uses proper color scheme
- ✅ **Constants** - Centralized color management
- ✅ **Consistency** - Same colors used throughout app

## 🎯 Summary

**Your app now has:**
- ✅ **Minimal color palette** - Black, white, and custom grey
- ✅ **Consistent theming** - All components use the same colors
- ✅ **Material Design integration** - Proper color scheme mapping
- ✅ **Centralized constants** - Easy to maintain and update
- ✅ **Professional appearance** - Clean, modern black and white design

**The color scheme creates:**
- High contrast for excellent readability
- Clean, professional appearance
- Consistent visual hierarchy
- Easy maintenance and updates

---

**Your app now has a beautiful, minimal black and white color scheme!** ✨

Run the app to see the clean, professional design with your custom grey accents.
