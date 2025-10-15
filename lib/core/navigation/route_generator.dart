import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/splash/splash_page.dart';
import '../../features/welcome/welcome_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/presentation/pages/spaces_page.dart';
import '../../features/inventory/presentation/pages/create_space_page.dart';
import '../../features/inventory/presentation/pages/storages_page.dart';
import '../../features/inventory/presentation/pages/items_page.dart';
import '../../features/inventory/domain/entities/space_entity.dart';
import '../../features/inventory/domain/entities/storage_entity.dart';
import 'app_routes.dart';

/// Centralized route generator for the app
/// Handles all route generation and parameter passing
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract arguments
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );

      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
          settings: settings,
        );

      case AppRoutes.spaces:
        return MaterialPageRoute(
          builder: (_) => const SpacesPage(),
          settings: settings,
        );

      case AppRoutes.createSpace:
        return MaterialPageRoute(
          builder: (_) => const CreateSpacePage(),
          settings: settings,
        );

      case AppRoutes.storages:
        if (args is SpaceEntity) {
          return MaterialPageRoute(
            builder: (_) => StoragesPage(space: args),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

      case AppRoutes.items:
        if (args is Map<String, dynamic> &&
            args['space'] is SpaceEntity &&
            args['storage'] is StorageEntity) {
          return MaterialPageRoute(
            builder: (_) =>
                ItemsPage(space: args['space'], storage: args['storage']),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

      default:
        return _errorRoute(settings.name);
    }
  }

  /// Error route for undefined or invalid routes
  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                routeName != null ? 'Route: $routeName' : 'Unknown route',
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back or to home
                },
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
