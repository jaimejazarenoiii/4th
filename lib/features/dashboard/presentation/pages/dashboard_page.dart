import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          // User info and sign out
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return PopupMenuButton<String>(
                  icon: CircleAvatar(
                    backgroundColor: AppColors.black,
                    child: Text(
                      state.user.email.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'signout') {
                      context.read<AuthBloc>().add(SignOutEvent());
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(width: 8),
                          Text(
                            state.user.name ?? state.user.email,
                            style: GoogleFonts.outfit(),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'signout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.outfit(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.user.name ?? state.user.email,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
            
            const SizedBox(height: 32),
            
            // Quick actions grid
            Text(
              'Quick Actions',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    title: 'Spaces',
                    subtitle: 'Manage your spaces',
                    icon: Icons.home_outlined,
                    onTap: () => NavigationService.navigateTo(AppRoutes.spaces),
                  ),
                  _buildActionCard(
                    title: 'Profile',
                    subtitle: 'View your profile',
                    icon: Icons.person_outline,
                    onTap: () {
                      // TODO: Navigate to profile page
                    },
                  ),
                  _buildActionCard(
                    title: 'Settings',
                    subtitle: 'App preferences',
                    icon: Icons.settings_outlined,
                    onTap: () {
                      // TODO: Navigate to settings page
                    },
                  ),
                  _buildActionCard(
                    title: 'Help',
                    subtitle: 'Get support',
                    icon: Icons.help_outline,
                    onTap: () {
                      // TODO: Navigate to help page
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: AppColors.black,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
