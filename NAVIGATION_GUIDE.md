# Navigation Guide

## 🧭 Overview

The app uses a centralized navigation system with:
- **Named routes** for type-safe navigation
- **NavigationService** for navigation without BuildContext
- **RouteGenerator** for centralized route management
- **Route constants** to avoid hardcoded strings

## 📁 Structure

```
lib/core/navigation/
├── app_routes.dart         # Route name constants
├── route_generator.dart    # Route generation logic
└── navigation_service.dart # Navigation helper methods
```

## 🚀 Quick Start

### Basic Navigation

**Navigate to a page:**
```dart
// Using NavigationService (recommended)
NavigationService.navigateTo(AppRoutes.spaces);

// Or using context
Navigator.pushNamed(context, AppRoutes.spaces);
```

**Navigate with arguments:**
```dart
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: spaceEntity,
);
```

**Go back:**
```dart
NavigationService.goBack();
// Or
Navigator.pop(context);
```

## 📋 Available Routes

All route names are defined in `lib/core/navigation/app_routes.dart`:

| Route Constant | Path | Description |
|---------------|------|-------------|
| `AppRoutes.splash` | `/` | Splash screen (initial route) |
| `AppRoutes.spaces` | `/spaces` | Spaces list |
| `AppRoutes.storages` | `/storages` | Storages list (requires SpaceEntity) |
| `AppRoutes.items` | `/items` | Items list (requires Map with space & storage) |

## 🎯 Navigation Service Methods

### Navigate to Named Route

```dart
// Simple navigation
NavigationService.navigateTo(AppRoutes.spaces);

// With arguments
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: spaceEntity,
);
```

### Replace Current Route

```dart
// Replace current screen with new one
NavigationService.replaceWith(AppRoutes.spaces);
```

### Navigate and Clear Stack

```dart
// Go to a route and remove all previous routes
NavigationService.navigateToAndRemoveUntil(AppRoutes.spaces);
```

### Go Back

```dart
// Simple back
NavigationService.goBack();

// With result
NavigationService.goBack(result: 'some_value');
```

### Check if Can Go Back

```dart
if (NavigationService.canGoBack()) {
  NavigationService.goBack();
} else {
  // Handle case when can't go back
}
```

### Pop Until Specific Route

```dart
// Pop until reaching a specific route
NavigationService.popUntil(AppRoutes.spaces);
```

## 💬 Dialogs & Snackbars

### Show Dialog

```dart
NavigationService.showAppDialog(
  dialog: AlertDialog(
    title: Text('Confirmation'),
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

### Show Bottom Sheet

```dart
NavigationService.showAppBottomSheet(
  child: Container(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Bottom Sheet Content'),
        // More content...
      ],
    ),
  ),
);
```

### Show Snackbar

```dart
// Basic snackbar
NavigationService.showSnackBar(message: 'Operation completed');

// Success message (green)
NavigationService.showSuccess('Successfully saved!');

// Error message (red)
NavigationService.showError('Something went wrong');

// Info message (blue)
NavigationService.showInfo('Please note this information');

// Custom snackbar
NavigationService.showSnackBar(
  message: 'Custom message',
  duration: Duration(seconds: 5),
  backgroundColor: Colors.orange,
  action: SnackBarAction(
    label: 'UNDO',
    onPressed: () {
      // Handle undo
    },
  ),
);
```

## 🔧 Advanced Usage

### Custom Route Transition

If you need a custom transition (not supported by named routes):

```dart
NavigationService.navigateWithRoute(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return YourCustomPage();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
```

### Passing Complex Arguments

For routes that need multiple arguments:

```dart
// Items page needs both space and storage
NavigationService.navigateTo(
  AppRoutes.items,
  arguments: {
    'space': spaceEntity,
    'storage': storageEntity,
  },
);
```

### Adding New Routes

**1. Add route constant** in `app_routes.dart`:
```dart
class AppRoutes {
  static const String settings = '/settings';
  static const String profile = '/profile';
}
```

**2. Handle route** in `route_generator.dart`:
```dart
switch (settings.name) {
  // ... existing routes ...
  
  case AppRoutes.settings:
    return MaterialPageRoute(
      builder: (_) => const SettingsPage(),
      settings: settings,
    );
    
  case AppRoutes.profile:
    if (args is UserEntity) {
      return MaterialPageRoute(
        builder: (_) => ProfilePage(user: args),
        settings: settings,
      );
    }
    return _errorRoute(settings.name);
}
```

**3. Navigate to new route:**
```dart
NavigationService.navigateTo(AppRoutes.settings);
```

## 📱 Real-World Examples

### Example 1: Navigate from Spaces to Storages

```dart
// In SpacesPage
Card(
  onTap: () {
    NavigationService.navigateTo(
      AppRoutes.storages,
      arguments: spaceEntity,
    );
  },
  child: // ... card content
)
```

### Example 2: Navigate to Items

```dart
// In StoragesPage
Card(
  onTap: () {
    NavigationService.navigateTo(
      AppRoutes.items,
      arguments: {
        'space': space,
        'storage': storage,
      },
    );
  },
  child: // ... card content
)
```

### Example 3: Logout (Clear Stack)

```dart
void logout() {
  // Clear user data
  // ...
  
  // Navigate to login and clear all previous screens
  NavigationService.navigateToAndRemoveUntil(AppRoutes.login);
}
```

### Example 4: Form Submission with Feedback

```dart
Future<void> submitForm() async {
  try {
    await saveData();
    NavigationService.showSuccess('Data saved successfully!');
    NavigationService.goBack(result: true);
  } catch (e) {
    NavigationService.showError('Failed to save: $e');
  }
}
```

### Example 5: Confirmation Dialog

```dart
void deleteItem() {
  NavigationService.showAppDialog(
    dialog: AlertDialog(
      title: Text('Delete Item'),
      content: Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () => NavigationService.goBack(),
          child: Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            // Perform delete
            context.read<InventoryBloc>().add(DeleteItemEvent(...));
            NavigationService.goBack(); // Close dialog
            NavigationService.showSuccess('Item deleted');
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
```

## ⚠️ Important Notes

### When to Use NavigationService vs Navigator

**Use NavigationService when:**
- ✅ You don't have BuildContext available (e.g., in BLoC, services)
- ✅ You want cleaner, more readable code
- ✅ You need to navigate from business logic layer
- ✅ You want centralized navigation handling

**Use Navigator directly when:**
- You need very specific custom transitions
- You're working in a StatefulWidget and have context readily available

### BuildContext Consideration

NavigationService uses a global navigator key, which means:
- ✅ Can navigate from anywhere (BLoC, services, etc.)
- ✅ No need to pass context around
- ⚠️ Make sure MaterialApp is initialized before using

### Error Handling

If a route is not found or arguments are invalid:
- An error page is shown with a helpful message
- The error includes the route name that was attempted
- User can navigate back to safety

## 🎨 Best Practices

1. **Use Route Constants**: Always use `AppRoutes.routeName` instead of strings
   ```dart
   // Good ✅
   NavigationService.navigateTo(AppRoutes.spaces);
   
   // Bad ❌
   Navigator.pushNamed(context, '/spaces');
   ```

2. **Type-Safe Arguments**: Define expected argument types in RouteGenerator
   ```dart
   if (args is SpaceEntity) {
     return MaterialPageRoute(...);
   }
   ```

3. **Handle Missing Arguments**: Always check for null/invalid arguments
   ```dart
   if (args == null) {
     return _errorRoute(settings.name);
   }
   ```

4. **Use Named Routes for Main Flows**: Save custom transitions for special cases

5. **Show Feedback**: Use snackbars to confirm actions
   ```dart
   NavigationService.showSuccess('Item created!');
   ```

## 🔍 Debugging

### Check Current Route

```dart
// Get current route name
final currentRoute = ModalRoute.of(context)?.settings.name;
print('Current route: $currentRoute');
```

### Navigation Stack

```dart
// Check if can pop (has previous route)
if (NavigationService.canGoBack()) {
  print('Can navigate back');
}
```

### Route Arguments

```dart
// In your page, access arguments
@override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  print('Received arguments: $args');
  // ...
}
```

## 📚 Related Files

- `lib/main.dart` - Navigator key and route generator setup
- `lib/core/navigation/app_routes.dart` - Route constants
- `lib/core/navigation/route_generator.dart` - Route handling
- `lib/core/navigation/navigation_service.dart` - Navigation helpers

## 🎯 Summary

**Before (Old Way):**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => StoragesPage(space: space),
  ),
);
```

**After (New Way):**
```dart
NavigationService.navigateTo(
  AppRoutes.storages,
  arguments: space,
);
```

**Benefits:**
- ✅ Cleaner code
- ✅ Type-safe routes
- ✅ Centralized management
- ✅ Navigate without context
- ✅ Easy to test
- ✅ Better error handling
- ✅ Consistent navigation throughout app

---

**Happy navigating! 🚀**

