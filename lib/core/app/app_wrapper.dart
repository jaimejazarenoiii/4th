import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../navigation/navigation_service.dart';
import '../navigation/app_routes.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/splash/splash_page.dart';
import '../../features/welcome/welcome_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

/// Main app wrapper that handles authentication state and routing
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _minSplashTimePassed = false;

  @override
  void initState() {
    super.initState();
    
    // Ensure splash animations complete before navigation
    // Total time: 1500ms (logo) + 200ms (delay) + 1200ms (text) + 2000ms (pulse cycle) + 1000ms (extra) = 5900ms
    // Rounding to 6 seconds to ensure all animations complete smoothly
    Future.delayed(const Duration(milliseconds: 5900), () {
      if (mounted) {
        setState(() {
          _minSplashTimePassed = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated && _minSplashTimePassed) {
          // Navigate to dashboard when authenticated
          NavigationService.replaceWith(AppRoutes.dashboard);
        } else if (state is AuthUnauthenticated && _minSplashTimePassed) {
          // Navigate to welcome when not authenticated
          NavigationService.replaceWith(AppRoutes.welcome);
        } else if (state is AuthError && _minSplashTimePassed) {
          // Navigate to welcome on error
          NavigationService.replaceWith(AppRoutes.welcome);
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Always show splash screen until minimum time has passed
          if (!_minSplashTimePassed) {
            return const SplashPage();
          }
          
          if (state is AuthChecking || state is AuthInitial) {
            // Show splash screen while checking authentication
            return const SplashPage();
          } else if (state is AuthAuthenticated) {
            // Show dashboard for authenticated users
            return const DashboardPage();
          } else if (state is AuthUnauthenticated) {
            // Show welcome screen for unauthenticated users
            return const WelcomePage();
          } else if (state is AuthLoading) {
            // Show loading screen during auth operations
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Default to splash screen
            return const SplashPage();
          }
        },
      ),
    );
  }
}
