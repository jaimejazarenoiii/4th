import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../../../core/navigation/navigation_service.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/section_header.dart';
import '../widgets/space_card.dart';
import '../widgets/storage_card.dart';
import '../widgets/item_row.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../inventory/presentation/pages/create_space_page.dart';
import '../../../inventory/presentation/bloc/create_space_bloc.dart';
import '../../../inventory/presentation/pages/create_storage_page.dart';
import '../../../inventory/presentation/bloc/create_storage_bloc.dart';
import '../../../inventory/presentation/pages/create_item_page.dart';
import '../../../inventory/presentation/bloc/create_item_bloc.dart';
import '../../../inventory/domain/entities/space_entity.dart';

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
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const RefreshDashboardData());
              // Wait for the refresh to complete
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                      context.read<AuthBloc>().add(
                                        SignOutEvent(),
                                      );
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
                        _navigateToCreateSpace(context);
                      },
                    ),

                    const SizedBox(height: 16),
                    // Spaces list with API data
                    BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (context, state) {
                        if (state is DashboardLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DashboardLoaded) {
                          if (state.dashboardData.spaces.isEmpty) {
                            return SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'No space yet',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: state.dashboardData.spaces.map((
                                  space,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      child: RepaintBoundary(
                                        child: SpaceCard(
                                          name: space.name,
                                          description: space.description ?? '',
                                          totalStorages: space.storagesCount,
                                          totalItems: space.itemsCount,
                                          onTap: () {
                                            _navigateToSpaceDetails(
                                              context,
                                              space,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        } else if (state is DashboardError) {
                          return Center(
                            child: Text(
                              'Error loading spaces: ${state.message}',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'No space yet',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Quick actions grid
                    SectionHeader(
                      title: 'Storages',
                      actionText: 'Add',
                      actionIcon: Icons.add,
                      onActionPressed: () {
                        _navigateToCreateStorage(context);
                      },
                    ),

                    const SizedBox(height: 16),
                    // Storages list with API data
                    BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (context, state) {
                        if (state is DashboardLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DashboardLoaded) {
                          if (state.dashboardData.storages.isEmpty) {
                            return SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'No storage yet',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: state.dashboardData.storages.map((
                                  storage,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      child: RepaintBoundary(
                                        child: StorageCard(
                                          name: storage.name,
                                          description:
                                              'Found in ${storage.locationPath}',
                                          totalStorages:
                                              1, // Each storage is in one space
                                          totalItems: storage.totalItemsCount,
                                          onTap: () {
                                            // Debug: Print storage object to see what fields are available
                                            print(
                                              'DEBUG: storage object = $storage',
                                            );
                                            print(
                                              'DEBUG: storage.locationPath = "${storage.locationPath}"',
                                            );
                                            print(
                                              'DEBUG: storage.spaceName = "${storage.spaceName}"',
                                            );

                                            _navigateToStorageDetails(
                                              context,
                                              storage,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }
                        } else if (state is DashboardError) {
                          return Center(
                            child: Text(
                              'Error loading storages: ${state.message}',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'No storage yet',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    SectionHeader(
                      title: 'Items',
                      actionText: 'Add',
                      actionIcon: Icons.add,
                      onActionPressed: () {
                        _navigateToCreateItem(context);
                      },
                    ),

                    const SizedBox(height: 16),
                    // Items list with API data
                    BlocBuilder<DashboardBloc, DashboardState>(
                      builder: (context, state) {
                        if (state is DashboardLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is DashboardLoaded) {
                          if (state.dashboardData.items.isEmpty) {
                            return SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'No items yet',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: state.dashboardData.items.map((item) {
                                return ItemRow(
                                  itemName: item.name,
                                  expiryDate:
                                      'No expiry date', // API doesn't provide expiry dates
                                  description: item.notes ?? '',
                                  locationPath:
                                      '${item.spaceName} > ${item.storageName}',
                                  quantity: item.quantity,
                                  onTap: () {
                                    _navigateToItemDetails(context, item);
                                  },
                                );
                              }).toList(),
                            );
                          }
                        } else if (state is DashboardError) {
                          return Center(
                            child: Text(
                              'Error loading items: ${state.message}',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'No items yet',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCreateSpace(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [BlocProvider(create: (context) => sl<CreateSpaceBloc>())],
          child: CreateSpacePage(
            onSpaceCreated: () {
              // Reload dashboard when space is created
              dashboardBloc.add(const RefreshDashboardData());
            },
          ),
        ),
      ),
    );
  }

  void _navigateToCreateStorage(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    final dashboardState = dashboardBloc.state;

    if (dashboardState is DashboardLoaded) {
      if (dashboardState.dashboardData.spaces.isEmpty) {
        // Show error if no spaces exist
        NavigationService.showError(
          'Please create a space first before adding storage',
        );
        return;
      }

      if (dashboardState.dashboardData.spaces.length == 1) {
        // If only one space, navigate directly
        final space = dashboardState.dashboardData.spaces.first;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => sl<CreateStorageBloc>(),
              child: CreateStoragePage(
                spaceId: space.id.toString(),
                spaceName: space.name,
                onStorageCreated: () {
                  // Reload dashboard when storage is created
                  dashboardBloc.add(const RefreshDashboardData());
                },
              ),
            ),
          ),
        );
      } else {
        // Show space selection dialog if multiple spaces exist
        _showSpaceSelectionDialog(context, dashboardState.dashboardData.spaces);
      }
    }
  }

  void _showSpaceSelectionDialog(BuildContext context, List<dynamic> spaces) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Space',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                final space = spaces[index];
                return ListTile(
                  title: Text(space.name, style: GoogleFonts.outfit()),
                  subtitle:
                      space.description != null && space.description.isNotEmpty
                      ? Text(
                          space.description,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    final dashboardBloc = context.read<DashboardBloc>();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => sl<CreateStorageBloc>(),
                          child: CreateStoragePage(
                            spaceId: space.id.toString(),
                            spaceName: space.name,
                            onStorageCreated: () {
                              // Reload dashboard when storage is created
                              dashboardBloc.add(const RefreshDashboardData());
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.outfit(color: AppColors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToItemDetails(BuildContext context, dynamic item) {
    NavigationService.navigateTo(
      AppRoutes.itemDetails,
      arguments: {
        'itemId': item.id.toString(),
        'storageId': item.storageId.toString(),
        'spaceId': null, // Will be searched if not provided
        'spaceName': item.spaceName,
        'storageName': item.storageName,
      },
    );
  }

  void _navigateToSpaceDetails(BuildContext context, dynamic space) {
    // Convert DashboardSpaceModel to SpaceEntity
    final spaceEntity = SpaceEntity(
      id: space.id.toString(),
      name: space.name,
      description: space.description,
      image: null, // Dashboard doesn't provide image data
      storages: const [], // Empty list - will be loaded by StoragesPage
      createdAt: space.createdAt,
      updatedAt: space.updatedAt,
    );

    NavigationService.navigateTo(AppRoutes.storages, arguments: spaceEntity);
  }

  void _navigateToStorageDetails(BuildContext context, dynamic storage) {
    NavigationService.navigateTo(
      AppRoutes.storageDetails,
      arguments: {'storageId': storage.id.toString()},
    );
  }

  void _navigateToCreateItem(BuildContext context) {
    final dashboardBloc = context.read<DashboardBloc>();
    final dashboardState = dashboardBloc.state;

    if (dashboardState is DashboardLoaded) {
      if (dashboardState.dashboardData.spaces.isEmpty) {
        // Show error if no spaces exist
        NavigationService.showError(
          'Please create a space first before adding items',
        );
        return;
      }

      // Find storages in the first space (or use defaults)
      final firstSpace = dashboardState.dashboardData.spaces.first;
      final storagesInSpace = dashboardState.dashboardData.storages
          .where((storage) => storage.spaceId == firstSpace.id)
          .toList();

      // Use first space and first storage if available, otherwise let user select on the page
      final defaultSpace = firstSpace;
      final defaultStorage = storagesInSpace.isNotEmpty
          ? storagesInSpace.first
          : null;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<CreateItemBloc>(),
            child: CreateItemPage(
              spaceId: defaultSpace.id.toString(),
              spaceName: defaultSpace.name,
              storageId: defaultStorage?.id.toString() ?? '',
              storageName: defaultStorage?.name ?? '',
              onItemCreated: () {
                // Reload dashboard when item is created
                dashboardBloc.add(const RefreshDashboardData());
              },
            ),
          ),
        ),
      );
    }
  }
}
