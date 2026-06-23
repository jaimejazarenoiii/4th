import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../di/injection_container.dart';
import '../../features/splash/splash_page.dart';
import '../../features/welcome/welcome_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/presentation/pages/spaces_page.dart';
import '../../features/inventory/presentation/pages/create_space_page.dart';
import '../../features/inventory/presentation/pages/create_storage_page.dart';
import '../../features/inventory/presentation/pages/location_selection_page.dart';
import '../../features/inventory/presentation/pages/storage_details_page.dart';
import '../../features/inventory/presentation/bloc/create_space_bloc.dart';
import '../../features/inventory/presentation/bloc/create_storage_bloc.dart';
import '../../features/inventory/presentation/bloc/location_selection_bloc.dart';
import '../../features/inventory/presentation/bloc/storage_details_bloc.dart';
import '../../features/inventory/presentation/pages/storages_page.dart';
import '../../features/inventory/presentation/pages/items_page.dart';
import '../../features/inventory/presentation/pages/create_item_page.dart';
import '../../features/inventory/presentation/bloc/create_item_bloc.dart';
import '../../features/inventory/presentation/pages/item_details_page.dart';
import '../../features/inventory/presentation/bloc/item_details_bloc.dart';
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
          builder: (_) => BlocProvider(
            create: (context) => sl<CreateSpaceBloc>(),
            child: const CreateSpacePage(),
          ),
          settings: settings,
        );

      case AppRoutes.createStorage:
        if (args is Map<String, dynamic> &&
            args['spaceId'] is String &&
            args['spaceName'] is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<CreateStorageBloc>(),
              child: CreateStoragePage(
                spaceId: args['spaceId'],
                spaceName: args['spaceName'],
                onStorageCreated: args['onStorageCreated'],
              ),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

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

      case AppRoutes.storageDetails:
        if (args is Map<String, dynamic> && args['storageId'] is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<StorageDetailsBloc>(),
              child: StorageDetailsPage(storageId: args['storageId']),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

      case AppRoutes.locationSelection:
        if (args is Map<String, dynamic> && args['title'] is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<LocationSelectionBloc>(),
              child: LocationSelectionPage(
                title: args['title'],
                currentLocationPath: args['currentLocationPath'],
                onLocationSelected: args['onLocationSelected'],
              ),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

      case AppRoutes.createItem:
        if (args is Map<String, dynamic> &&
            args['spaceId'] is String &&
            args['spaceName'] is String &&
            args['storageId'] is String &&
            args['storageName'] is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<CreateItemBloc>(),
              child: CreateItemPage(
                spaceId: args['spaceId'],
                spaceName: args['spaceName'],
                storageId: args['storageId'],
                storageName: args['storageName'],
                onItemCreated: args['onItemCreated'],
              ),
            ),
            settings: settings,
          );
        }
        return _errorRoute(settings.name);

      case AppRoutes.itemDetails:
        if (args is Map<String, dynamic> && args['itemId'] is String) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<ItemDetailsBloc>(),
              child: ItemDetailsPage(
                itemId: args['itemId'],
                storageId: args['storageId'],
                spaceId: args['spaceId'],
                spaceName: args['spaceName'],
                storageName: args['storageName'],
              ),
            ),
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
