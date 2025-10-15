import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/section_header.dart';
import '../widgets/space_card.dart';
import '../widgets/storage_card.dart';
import '../widgets/item_row.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigationService.replaceWith(AppRoutes.welcome);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hi ',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Jaime,\n',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Welcome back!',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthAuthenticated) {
                            return PopupMenuButton<String>(
                              icon: Container(
                                width: 60, // 2x radius
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.white,
                                  backgroundImage: const AssetImage(
                                    AssetConstants.avatarIcon,
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
                                        'Jaime Jazareno',
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
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick actions grid
                SectionHeader(
                  title: 'Spaces',
                  actionText: 'Add',
                  actionIcon: Icons.add,
                  onActionPressed: () {
                    NavigationService.navigateTo(AppRoutes.createSpace);
                  },
                ),

                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(5, (index) {
                      final spaceNames = [
                        'Living Room',
                        'Kitchen',
                        'Bedroom',
                        'Garage',
                        'Office',
                      ];
                      final spaceDescriptions = [
                        'Main living space',
                        'Cook & eat',
                        'Sleep & relax',
                        'Tools & storage',
                        'Work area',
                      ];
                      final storages = [2, 3, 1, 5, 4];
                      final items = [10, 12, 6, 20, 8];

                      return Padding(
                        padding: EdgeInsets.only(right: index < 4 ? 16.0 : 0.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: RepaintBoundary(
                            child: SpaceCard(
                              name: spaceNames[index],
                              description: spaceDescriptions[index],
                              totalStorages: storages[index],
                              totalItems: items[index],
                              onTap: () {
                                // TODO: Handle space card tap
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 32),

                // Quick actions grid
                SectionHeader(
                  title: 'Storages',
                  actionText: 'Add',
                  actionIcon: Icons.add,
                  onActionPressed: () {
                    // TODO: Handle add action
                  },
                ),

                const SizedBox(height: 16),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(5, (index) {
                      // Mock data for each storage
                      final storageNames = [
                        'Bookshelf',
                        'Pantry',
                        'Wardrobe',
                        'Tool Chest',
                        'File Cabinet Cabinet Cabinet',
                      ];
                      final storageFoundIn = [
                        'Found in Living Room',
                        'Found in Kitchen',
                        'Found in Bedroom',
                        'Found in Garage',
                        'Found in Office',
                      ];
                      final totalSpaces = [1, 2, 1, 1, 1];
                      final totalItems = [25, 40, 30, 12, 90];

                      return Padding(
                        padding: EdgeInsets.only(right: index < 4 ? 16.0 : 0.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: RepaintBoundary(
                            child: StorageCard(
                              name: storageNames[index],
                              description: storageFoundIn[index],
                              totalStorages: totalSpaces[index],
                              totalItems: totalItems[index],
                              onTap: () {
                                // TODO: Handle space card tap
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 32),

                SectionHeader(
                  title: 'Items',
                  actionText: 'Add',
                  actionIcon: Icons.add,
                  onActionPressed: () {
                    // TODO: Handle add action
                  },
                ),

                const SizedBox(height: 16),

                Column(
                  children: List.generate(5, (index) {
                    // Mock data for each item
                    final itemNames = [
                      'Soy sauce bottle',
                      'Milk carton',
                      'Bread loaf',
                      'Olive oil bottle',
                      'Canned soup',
                    ];
                    final expiryDates = [
                      'Sept. 29, 1996',
                      'Dec. 15, 2024',
                      'Jan. 8, 2024',
                      'Mar. 22, 2025',
                      'Feb. 14, 2025',
                    ];
                    final descriptions = [
                      'Asian condiment for cooking',
                      'Fresh dairy milk product',
                      'Whole grain bread',
                      'Extra virgin olive oil',
                      'Tomato and vegetable soup',
                    ];
                    final locations = [
                      'Kitchen > Cabinet A > Sub Container 1 > Sub Container 2 > Sub Container 3',
                      'Kitchen > Refrigerator > Door',
                      'Kitchen > Counter > Bread box',
                      'Kitchen > Cabinet B > Top shelf',
                      'Kitchen > Pantry > Canned goods',
                    ];
                    final quantities = [2, 1, 3, 1, 4];

                    return ItemRow(
                      itemName: itemNames[index],
                      expiryDate: expiryDates[index],
                      description: descriptions[index],
                      locationPath: locations[index],
                      quantity: quantities[index],
                      onTap: () {
                        // TODO: Handle item tap
                      },
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildActionCard(
                        title: 'Spaces',
                        subtitle: 'Manage your spaces',
                        icon: Icons.home_outlined,
                        onTap: () =>
                            NavigationService.navigateTo(AppRoutes.spaces),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: AppColors.black),
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
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
