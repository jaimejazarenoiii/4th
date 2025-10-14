import 'package:flutter/material.dart';

/// Navigation service for easy navigation throughout the app
/// Can be used without BuildContext by using the global navigator key
class NavigationService {
  // Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get the current context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  // Navigate to a named route
  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  // Navigate to a named route and remove all previous routes
  static Future<dynamic> navigateToAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Replace current route with a new named route
  static Future<dynamic> replaceWith(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  // Go back to previous screen
  static void goBack({dynamic result}) {
    return navigatorKey.currentState!.pop(result);
  }

  // Check if can go back
  static bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  // Pop until a specific route
  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(
      ModalRoute.withName(routeName),
    );
  }

  // Navigate with custom page route
  static Future<dynamic> navigateWithRoute(Route<dynamic> route) {
    return navigatorKey.currentState!.push(route);
  }

  // Show dialog
  static Future<T?> showAppDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: navigatorKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  // Show bottom sheet
  static Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: navigatorKey.currentContext!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (_) => child,
    );
  }

  // Show snackbar
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
          backgroundColor: backgroundColor,
        ),
      );
    }
  }

  // Show success message
  static void showSuccess(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.green,
    );
  }

  // Show error message
  static void showError(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.red,
    );
  }

  // Show info message
  static void showInfo(String message) {
    showSnackBar(
      message: message,
      backgroundColor: Colors.blue,
    );
  }
}

