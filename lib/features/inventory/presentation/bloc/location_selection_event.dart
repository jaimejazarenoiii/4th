import 'package:equatable/equatable.dart';

abstract class LocationSelectionEvent extends Equatable {
  const LocationSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSpaces extends LocationSelectionEvent {
  const LoadSpaces();
}

class LoadStoragesForSpace extends LocationSelectionEvent {
  final String spaceId;
  final String spaceName;

  const LoadStoragesForSpace({required this.spaceId, required this.spaceName});

  @override
  List<Object> get props => [spaceId, spaceName];
}

class LoadChildStorages extends LocationSelectionEvent {
  final String parentStorageId;
  final String parentStorageName;
  final String spaceId;
  final String spaceName;

  const LoadChildStorages({
    required this.parentStorageId,
    required this.parentStorageName,
    required this.spaceId,
    required this.spaceName,
  });

  @override
  List<Object> get props => [
    parentStorageId,
    parentStorageName,
    spaceId,
    spaceName,
  ];
}

class LoadItemsForStorage extends LocationSelectionEvent {
  final String storageId;
  final String storageName;
  final String spaceId;
  final String spaceName;

  const LoadItemsForStorage({
    required this.storageId,
    required this.storageName,
    required this.spaceId,
    required this.spaceName,
  });

  @override
  List<Object> get props => [storageId, storageName, spaceId, spaceName];
}

class SelectLocation extends LocationSelectionEvent {
  final String locationId;
  final String locationName;
  final String locationPath;
  final String locationType;
  final String? spaceId;

  const SelectLocation({
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

class NavigateBack extends LocationSelectionEvent {
  const NavigateBack();
}

class ResetLocationSelection extends LocationSelectionEvent {
  const ResetLocationSelection();
}

class HighlightLocation extends LocationSelectionEvent {
  final String locationId;
  final String locationName;
  final String locationPath;
  final String locationType;
  final String? spaceId;

  const HighlightLocation({
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
