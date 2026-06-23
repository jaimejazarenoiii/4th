import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';

abstract class LocationSelectionState extends Equatable {
  const LocationSelectionState();

  @override
  List<Object?> get props => [];
}

class LocationSelectionInitial extends LocationSelectionState {
  const LocationSelectionInitial();
}

class LocationSelectionLoading extends LocationSelectionState {
  const LocationSelectionLoading();
}

class LocationSelectionLoaded extends LocationSelectionState {
  final List<LocationEntity> locations;
  final String currentPath;
  final String? selectedLocationId;
  final String? selectedLocationName;
  final String? selectedLocationPath;
  final String? selectedLocationType;
  final String? selectedSpaceId;

  const LocationSelectionLoaded({
    required this.locations,
    required this.currentPath,
    this.selectedLocationId,
    this.selectedLocationName,
    this.selectedLocationPath,
    this.selectedLocationType,
    this.selectedSpaceId,
  });

  @override
  List<Object?> get props => [
    locations,
    currentPath,
    selectedLocationId,
    selectedLocationName,
    selectedLocationPath,
    selectedLocationType,
    selectedSpaceId,
  ];
}

class LocationSelectionError extends LocationSelectionState {
  final String message;

  const LocationSelectionError({required this.message});

  @override
  List<Object> get props => [message];
}

class LocationSelected extends LocationSelectionState {
  final String locationId;
  final String locationName;
  final String locationPath;
  final String locationType;
  final String? spaceId;

  const LocationSelected({
    required this.locationId,
    required this.locationName,
    required this.locationPath,
    required this.locationType,
    this.spaceId,
  });

  @override
  List<Object?> get props => [
    locationId,
    locationName,
    locationPath,
    locationType,
    spaceId,
  ];
}
