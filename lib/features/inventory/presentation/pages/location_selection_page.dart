import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_selection_bloc.dart';
import '../bloc/location_selection_event.dart';
import '../bloc/location_selection_state.dart';

class LocationSelectionPage extends StatefulWidget {
  final String title;
  final String? currentLocationPath;
  final Function(
    String locationId,
    String locationName,
    String locationPath,
    String locationType,
    String? spaceId,
  )?
  onLocationSelected;

  const LocationSelectionPage({
    super.key,
    required this.title,
    this.currentLocationPath,
    this.onLocationSelected,
  });

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final List<NavigationLevel> _navigationStack = [];

  @override
  void initState() {
    super.initState();
    // Start by loading spaces
    context.read<LocationSelectionBloc>().add(const LoadSpaces());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          if (widget.currentLocationPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  'Current location',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Current location breadcrumb
          if (widget.currentLocationPath != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.grey.withValues(alpha: 0.1),
              child: Text(
                widget.currentLocationPath!,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Navigation breadcrumb
          BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
            builder: (context, state) {
              if (state is LocationSelectionLoaded) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (_navigationStack.isNotEmpty)
                        GestureDetector(
                          onTap: () => _navigateBack(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                                color: AppColors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _navigationStack.last.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          state.currentPath,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Location list
          Expanded(
            child: BlocListener<LocationSelectionBloc, LocationSelectionState>(
              listener: (context, state) {
                if (state is LocationSelected) {
                  widget.onLocationSelected?.call(
                    state.locationId,
                    state.locationName,
                    state.locationPath,
                    state.locationType,
                    state.spaceId,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
                builder: (context, state) {
                  if (state is LocationSelectionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LocationSelectionError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading locations',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<LocationSelectionBloc>().add(
                                const LoadSpaces(),
                              );
                            },
                            child: Text('Retry', style: GoogleFonts.outfit()),
                          ),
                        ],
                      ),
                    );
                  } else if (state is LocationSelectionLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.locations.length,
                      itemBuilder: (context, index) {
                        final location = state.locations[index];
                        return _buildLocationItem(location, state);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: AppColors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child:
                      BlocBuilder<
                        LocationSelectionBloc,
                        LocationSelectionState
                      >(
                        builder: (context, state) {
                          final isLocationSelected =
                              state is LocationSelectionLoaded &&
                              state.selectedLocationId != null;

                          return ElevatedButton(
                            onPressed: isLocationSelected
                                ? () {
                                    context.read<LocationSelectionBloc>().add(
                                      SelectLocation(
                                        locationId: state.selectedLocationId!,
                                        locationName:
                                            state.selectedLocationName!,
                                        locationPath:
                                            state.selectedLocationPath!,
                                        locationType:
                                            state.selectedLocationType ??
                                            'space',
                                        spaceId: state.selectedSpaceId,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLocationSelected
                                  ? Colors.black
                                  : AppColors.grey,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              'Select',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(
    LocationEntity location,
    LocationSelectionLoaded state,
  ) {
    final isSelected = state.selectedLocationId == location.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.grey.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          // Single tap: highlight the location
          context.read<LocationSelectionBloc>().add(
            HighlightLocation(
              locationId: location.id,
              locationName: location.name,
              locationPath: _buildLocationPath(location),
              locationType: location.type.name,
              spaceId: location is StorageLocationEntity
                  ? location.spaceId
                  : location.id,
            ),
          );
        },
        onDoubleTap: () {
          // Double tap: navigate to next level if possible
          if (_canNavigateDeeper(location)) {
            _navigateToLocation(location);
          } else {
            // If can't navigate deeper, select this location
            context.read<LocationSelectionBloc>().add(
              SelectLocation(
                locationId: location.id,
                locationName: location.name,
                locationPath: _buildLocationPath(location),
                locationType: location.type.name,
                spaceId: location is StorageLocationEntity
                    ? location.spaceId
                    : location.id,
              ),
            );
          }
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: _getLocationIcon(location),
          title: Text(
            location.name,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          subtitle:
              location.description != null && location.description!.isNotEmpty
              ? Text(
                  location.description!,
                  style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : _getLocationSubtitle(location),
          trailing: _canNavigateDeeper(location)
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.grey,
                )
              : null,
        ),
      ),
    );
  }

  Widget _getLocationIcon(LocationEntity location) {
    switch (location.type) {
      case LocationType.space:
        return const Icon(
          Icons.home_outlined,
          color: AppColors.black,
          size: 24,
        );
      case LocationType.storage:
        return const Icon(
          Icons.inventory_2_outlined,
          color: AppColors.black,
          size: 24,
        );
      case LocationType.item:
        return const Icon(
          Icons.category_outlined,
          color: AppColors.black,
          size: 24,
        );
    }
  }

  Widget? _getLocationSubtitle(LocationEntity location) {
    switch (location.type) {
      case LocationType.space:
        final space = location as SpaceLocationEntity;
        return Text(
          '${space.storagesCount} storages • ${space.itemsCount} items',
          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey),
        );
      case LocationType.storage:
        final storage = location as StorageLocationEntity;
        return Text(
          '${storage.itemsCount} items',
          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey),
        );
      case LocationType.item:
        final item = location as ItemLocationEntity;
        return Text(
          'Quantity: ${item.quantity}',
          style: GoogleFonts.outfit(fontSize: 14, color: AppColors.grey),
        );
    }
  }

  bool _canNavigateDeeper(LocationEntity location) {
    switch (location.type) {
      case LocationType.space:
        final space = location as SpaceLocationEntity;
        return space.storagesCount > 0;
      case LocationType.storage:
        final storage = location as StorageLocationEntity;
        // In browse flow, itemsCount represents children_count for storages
        return storage.itemsCount > 0;
      case LocationType.item:
        return false; // Items are the deepest level
    }
  }

  void _navigateToLocation(LocationEntity location) {
    // Add current level to navigation stack
    _navigationStack.add(
      NavigationLevel(title: location.name, location: location),
    );

    switch (location.type) {
      case LocationType.space:
        final space = location as SpaceLocationEntity;
        context.read<LocationSelectionBloc>().add(
          LoadStoragesForSpace(spaceId: space.id, spaceName: space.name),
        );
        break;
      case LocationType.storage:
        final storage = location as StorageLocationEntity;
        context.read<LocationSelectionBloc>().add(
          LoadChildStorages(
            parentStorageId: storage.id,
            parentStorageName: storage.name,
            spaceId: storage.spaceId,
            spaceName: storage.spaceName,
          ),
        );
        break;
      case LocationType.item:
        // Items are selectable, not navigable
        break;
    }
  }

  void _navigateBack() {
    if (_navigationStack.isNotEmpty) {
      _navigationStack.removeLast();

      if (_navigationStack.isEmpty) {
        // Go back to spaces
        context.read<LocationSelectionBloc>().add(const LoadSpaces());
      } else {
        // Go back to previous level
        final previousLevel = _navigationStack.last;
        _navigateToLocation(previousLevel.location);
      }
    }
  }

  String _buildLocationPath(LocationEntity location) {
    final pathParts = <String>[];

    // Add space name
    switch (location.type) {
      case LocationType.space:
        pathParts.add(location.name);
        break;
      case LocationType.storage:
        final storage = location as StorageLocationEntity;
        pathParts.add(storage.spaceName);
        pathParts.add(location.name);
        break;
      case LocationType.item:
        final item = location as ItemLocationEntity;
        pathParts.add(item.spaceName);
        pathParts.add(item.storageName);
        pathParts.add(location.name);
        break;
    }

    return pathParts.join(' > ');
  }
}

class NavigationLevel {
  final String title;
  final LocationEntity location;

  NavigationLevel({required this.title, required this.location});
}
