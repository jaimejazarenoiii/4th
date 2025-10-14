# Quick Start - Navigation

## ✅ What's Been Set Up

Your app now has a complete navigation system with:
- ✅ Named routes
- ✅ Navigation service (no BuildContext needed!)
- ✅ Route constants
- ✅ Error handling
- ✅ Dialogs & snackbars support

## 🚀 Basic Usage

### Navigate to a Page

```dart
import 'package:fourth/core/navigation/navigation_service.dart';
import 'package:fourth/core/navigation/app_routes.dart';

// Simple navigation
NavigationService.navigateTo(AppRoutes.spaces);

// With arguments
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: spaceEntity,
);
```

### Go Back

```dart
NavigationService.goBack();
```

### Show Messages

```dart
// Success (green)
NavigationService.showSuccess('Saved successfully!');

// Error (red)
NavigationService.showError('Something went wrong');

// Info (blue)
NavigationService.showInfo('Please note...');
```

## 📋 Available Routes

| Route | Use For | Arguments |
|-------|---------|-----------|
| `AppRoutes.splash` | Splash screen | None |
| `AppRoutes.spaces` | Spaces list | None |
| `AppRoutes.storages` | Storages in a space | `SpaceEntity` |
| `AppRoutes.items` | Items in storage | `Map` with space & storage |

## 💡 Common Patterns

### Navigate to Details Page

```dart
// When user taps a space card
onTap: () {
  NavigationService.navigateTo(
    AppRoutes.storages,
    arguments: space,
  );
}
```

### Show Confirmation Dialog

```dart
NavigationService.showAppDialog(
  dialog: AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => NavigationService.goBack(),
        child: Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          // Do something
          NavigationService.goBack();
        },
        child: Text('Confirm'),
      ),
    ],
  ),
);
```

### Replace Screen (No Back Button)

```dart
// Used in splash screen to go to main app
NavigationService.replaceWith(AppRoutes.spaces);
```

### Clear All and Navigate

```dart
// Useful for logout
NavigationService.navigateToAndRemoveUntil(AppRoutes.login);
```

## 🎯 Where It's Used

The navigation system is already implemented in:

**Splash Page** → Spaces Page:
```dart
NavigationService.replaceWith(AppRoutes.spaces);
```

**Spaces Page** → Storages Page:
```dart
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: space,
);
```

**Storages Page** → Items Page:
```dart
NavigationService.navigateTo(
  AppRoutes.items,
  arguments: {
    'space': space,
    'storage': storage,
  },
);
```

## 🔧 Adding New Routes

**Step 1:** Add constant in `lib/core/navigation/app_routes.dart`
```dart
static const String settings = '/settings';
```

**Step 2:** Handle in `lib/core/navigation/route_generator.dart`
```dart
case AppRoutes.settings:
  return MaterialPageRoute(
    builder: (_) => const SettingsPage(),
    settings: settings,
  );
```

**Step 3:** Navigate to it
```dart
NavigationService.navigateTo(AppRoutes.settings);
```

## 📚 Full Documentation

For complete details, see **NAVIGATION_GUIDE.md**

## ⚡ Benefits

### Before
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => StoragesPage(space: space),
  ),
);
```

### After
```dart
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: space,
);
```

**Advantages:**
- ✅ Cleaner code
- ✅ No typos in route names
- ✅ Navigate from anywhere (BLoC, services, etc.)
- ✅ Consistent throughout app
- ✅ Easy to refactor
- ✅ Better error handling

## 🎨 Examples You Can Copy

### Navigate on Button Press
```dart
ElevatedButton(
  onPressed: () {
    NavigationService.navigateTo(AppRoutes.spaces);
  },
  child: Text('Go to Spaces'),
)
```

### Navigate on Card Tap
```dart
Card(
  onTap: () {
    NavigationService.navigateTo(
      AppRoutes.storages,
      arguments: space,
    );
  },
  child: // ... card content
)
```

### Show Success After Save
```dart
Future<void> saveData() async {
  try {
    await repository.save();
    NavigationService.showSuccess('Saved!');
    NavigationService.goBack();
  } catch (e) {
    NavigationService.showError('Failed: $e');
  }
}
```

### Logout Flow
```dart
void logout() {
  // Clear data
  clearUserData();
  
  // Go to login and clear stack
  NavigationService.navigateToAndRemoveUntil(AppRoutes.login);
  
  // Show message
  NavigationService.showInfo('Logged out successfully');
}
```

---

**Your navigation system is ready to use!** 🎉

Start using `NavigationService` and `AppRoutes` throughout your app for clean, maintainable navigation.

