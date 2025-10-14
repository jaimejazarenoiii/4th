# Consistent Animations Guide

## ✅ Implementation Complete

Your app now has **consistent, beautiful animations** across all pages using reusable animation widgets!

## 🎨 Animation System

### Core Animation Widgets

**Location:** `lib/core/widgets/animated_page_wrapper.dart`

Four reusable animation widgets:

1. **AnimatedPageWrapper** - Full page fade and slide
2. **AnimatedFadeIn** - Simple fade animation
3. **AnimatedSlideIn** - Simple slide animation  
4. **AnimatedFadeSlide** - Combined fade + slide (most used)

## 🎬 Animations Applied

### ✨ Welcome Screen
**Location:** `lib/features/welcome/welcome_page.dart`

**Staggered animations:**
- Image: Fade + Slide (100ms delay, 40px offset)
- Title: Fade + Slide (200ms delay, 30px offset)
- Subtitle: Fade + Slide (300ms delay, 25px offset)
- Buttons: Fade + Slide (400ms delay, 20px offset)

**Effect:** Smooth cascade from top to bottom

### 📦 Spaces Page
**Location:** `lib/features/inventory/presentation/pages/spaces_page.dart`

**List animations:**
- Each card: Fade + Slide with 50ms stagger
- Empty state: Fade + Slide (30px offset)

**Effect:** Cards appear sequentially from top to bottom

### 🗄️ Storages Page
**Location:** `lib/features/inventory/presentation/pages/storages_page.dart`

**List animations:**
- Each card: Fade + Slide with 50ms stagger
- Empty state: Fade + Slide (30px offset)

**Effect:** Consistent with spaces page

### 📋 Items Page
**Location:** `lib/features/inventory/presentation/pages/items_page.dart`

**List animations:**
- Each card: Fade + Slide with 50ms stagger
- Empty state: Fade + Slide (30px offset)

**Effect:** Consistent with spaces and storages pages

## 🔧 Animation Parameters

### Timing
```dart
// Page load animations
duration: Duration(milliseconds: 600)

// List item animations
duration: Duration(milliseconds: 400)

// Stagger delay per item
delay: Duration(milliseconds: 50 * index)
```

### Movement
```dart
// Empty states
offsetY: 30

// Welcome screen elements
offsetY: 40, 30, 25, 20 (cascading)

// List items
offsetY: 20
```

### Curves
```dart
// Default for all animations
curve: Curves.easeOut
```

## 💻 Usage Examples

### Basic Fade + Slide

```dart
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 600),
  offsetY: 30,
  child: YourWidget(),
)
```

### With Delay (Staggered)

```dart
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 400),
  delay: const Duration(milliseconds: 200),
  offsetY: 25,
  child: YourWidget(),
)
```

### List Items with Stagger

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return AnimatedFadeSlide(
      duration: const Duration(milliseconds: 400),
      delay: Duration(milliseconds: 50 * index),
      offsetY: 20,
      child: ItemCard(item: items[index]),
    );
  },
)
```

### Simple Fade In

```dart
AnimatedFadeIn(
  duration: const Duration(milliseconds: 500),
  delay: const Duration(milliseconds: 100),
  child: YourWidget(),
)
```

### Simple Slide In

```dart
AnimatedSlideIn(
  duration: const Duration(milliseconds: 500),
  offsetY: 40,
  child: YourWidget(),
)
```

### Full Page Wrapper

```dart
AnimatedPageWrapper(
  duration: const Duration(milliseconds: 600),
  slideOffset: 30.0,
  child: YourPageContent(),
)
```

## 🎯 Animation Patterns

### Pattern 1: Empty States

Used for "No items" messages:

```dart
Center(
  child: AnimatedFadeSlide(
    duration: const Duration(milliseconds: 600),
    offsetY: 30,
    child: Column(
      children: [
        Icon(...),
        Text('No items yet'),
        Text('Tap + to create'),
      ],
    ),
  ),
)
```

### Pattern 2: List Items

Used for cards in lists:

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return AnimatedFadeSlide(
      duration: const Duration(milliseconds: 400),
      delay: Duration(milliseconds: 50 * index),
      offsetY: 20,
      child: Card(...),
    );
  },
)
```

### Pattern 3: Staggered Content

Used for multiple elements appearing sequentially:

```dart
Column(
  children: [
    AnimatedFadeSlide(
      delay: const Duration(milliseconds: 100),
      offsetY: 40,
      child: Element1(),
    ),
    AnimatedFadeSlide(
      delay: const Duration(milliseconds: 200),
      offsetY: 30,
      child: Element2(),
    ),
    AnimatedFadeSlide(
      delay: const Duration(milliseconds: 300),
      offsetY: 25,
      child: Element3(),
    ),
  ],
)
```

## ⚙️ Customization

### Change Animation Speed

```dart
// Faster
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 300),
  child: YourWidget(),
)

// Slower
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 1000),
  child: YourWidget(),
)
```

### Change Slide Distance

```dart
// Subtle
AnimatedFadeSlide(
  offsetY: 10,
  child: YourWidget(),
)

// Dramatic
AnimatedFadeSlide(
  offsetY: 100,
  child: YourWidget(),
)
```

### Change Stagger Delay

```dart
// Faster stagger
delay: Duration(milliseconds: 30 * index)

// Slower stagger
delay: Duration(milliseconds: 100 * index)
```

### Change Animation Curve

Modify in `animated_page_wrapper.dart`:

```dart
// Bouncy
curve: Curves.elasticOut

// Sharp
curve: Curves.easeInOut

// Smooth (default)
curve: Curves.easeOut
```

## 🎨 Animation Widget API

### AnimatedFadeSlide

**Parameters:**
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 500ms)
- `delay` - Delay before starting (default: 0ms)
- `curve` - Animation curve (default: Curves.easeOut)
- `offsetY` - Vertical slide distance (default: 30px)

**Example:**
```dart
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 600),
  delay: const Duration(milliseconds: 200),
  curve: Curves.easeOut,
  offsetY: 40,
  child: Text('Hello'),
)
```

### AnimatedFadeIn

**Parameters:**
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 400ms)
- `delay` - Delay before starting (default: 0ms)
- `curve` - Animation curve (default: Curves.easeIn)

### AnimatedSlideIn

**Parameters:**
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 500ms)
- `delay` - Delay before starting (default: 0ms)
- `curve` - Animation curve (default: Curves.easeOut)
- `offsetY` - Vertical slide distance (default: 50px)
- `offsetX` - Horizontal slide distance (default: 0px)

### AnimatedPageWrapper

**Parameters:**
- `child` (required) - Widget to animate
- `duration` - Animation duration (default: 600ms)
- `curve` - Animation curve (default: Curves.easeOut)
- `enableFade` - Enable fade animation (default: true)
- `enableSlide` - Enable slide animation (default: true)
- `slideOffset` - Slide distance multiplier (default: 30.0)

## 🚀 Performance

**Optimizations:**
- ✅ Lightweight animation controllers
- ✅ Proper disposal of resources
- ✅ Efficient rendering with AnimatedBuilder
- ✅ No unnecessary rebuilds
- ✅ Smooth 60fps animations

**Best Practices:**
- Use `const` constructors where possible
- Limit stagger delay to prevent long waits
- Keep animation durations under 1 second
- Disable animations in accessibility settings if needed

## 📋 Complete Animation Checklist

### Splash Screen
- ✅ Logo animation (custom implementation)
- ✅ App name fade + slide
- ✅ Tagline fade + slide
- ✅ Pulse effect

### Welcome Screen
- ✅ Image fade + slide
- ✅ Title fade + slide
- ✅ Subtitle fade + slide
- ✅ Buttons fade + slide
- ✅ Staggered timing

### Spaces Page
- ✅ List items fade + slide
- ✅ Staggered appearance
- ✅ Empty state animation

### Storages Page
- ✅ List items fade + slide
- ✅ Staggered appearance
- ✅ Empty state animation

### Items Page
- ✅ List items fade + slide
- ✅ Staggered appearance
- ✅ Empty state animation

## 🎯 Animation Timing Reference

### Quick Reference

| Element | Duration | Delay | Offset |
|---------|----------|-------|--------|
| Welcome Image | 600ms | 100ms | 40px |
| Welcome Title | 600ms | 200ms | 30px |
| Welcome Subtitle | 600ms | 300ms | 25px |
| Welcome Buttons | 600ms | 400ms | 20px |
| List Items | 400ms | 50ms × index | 20px |
| Empty States | 600ms | 0ms | 30px |

## 🔧 Troubleshooting

### Animations not appearing?
- Check that widget is wrapped correctly
- Ensure delays aren't too long
- Verify animation controller is created

### Animations stuttering?
- Reduce number of simultaneous animations
- Decrease animation duration
- Check for heavy widgets in animated content

### List items animating all at once?
- Ensure delay calculation: `Duration(milliseconds: 50 * index)`
- Check that index is being passed correctly

## 🎨 Adding New Animations

### Step 1: Import the widget

```dart
import '../../../../core/widgets/animated_page_wrapper.dart';
```

### Step 2: Wrap your content

```dart
AnimatedFadeSlide(
  duration: const Duration(milliseconds: 600),
  offsetY: 30,
  child: YourContent(),
)
```

### Step 3: Adjust parameters

Test different durations, delays, and offsets to match your design.

## 📚 Related Files

- `lib/core/widgets/animated_page_wrapper.dart` - Animation widgets
- `lib/features/welcome/welcome_page.dart` - Welcome animations
- `lib/features/inventory/presentation/pages/spaces_page.dart` - Spaces animations
- `lib/features/inventory/presentation/pages/storages_page.dart` - Storages animations
- `lib/features/inventory/presentation/pages/items_page.dart` - Items animations

## 🎯 Summary

**Your app now has:**
- ✅ **Consistent animations** across all pages
- ✅ **Reusable animation widgets** for easy implementation
- ✅ **Staggered list items** for smooth appearance
- ✅ **Fade + slide effects** for professional look
- ✅ **Optimized performance** with proper cleanup
- ✅ **Customizable parameters** for fine-tuning
- ✅ **Beautiful empty states** with animations

**Animation Philosophy:**
- Smooth and subtle
- Consistent across the app
- Enhances user experience
- Doesn't slow down interaction
- Professional and modern

---

**Your app now flows beautifully with consistent animations!** ✨

Run `flutter run` to see the smooth transitions in action!
