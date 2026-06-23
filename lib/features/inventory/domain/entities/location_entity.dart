import 'package:equatable/equatable.dart';

abstract class LocationEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? parentId;
  final LocationType type;

  const LocationEntity({
    required this.id,
    required this.name,
    this.description,
    this.parentId,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, description, parentId, type];
}

enum LocationType { space, storage, item }

class SpaceLocationEntity extends LocationEntity {
  final int storagesCount;
  final int itemsCount;

  const SpaceLocationEntity({
    required super.id,
    required super.name,
    super.description,
    required this.storagesCount,
    required this.itemsCount,
  }) : super(type: LocationType.space);

  @override
  List<Object?> get props => [...super.props, storagesCount, itemsCount];
}

class StorageLocationEntity extends LocationEntity {
  final String spaceId;
  final String spaceName;
  final int itemsCount;

  const StorageLocationEntity({
    required super.id,
    required super.name,
    super.description,
    required this.spaceId,
    required this.spaceName,
    required this.itemsCount,
  }) : super(type: LocationType.storage, parentId: spaceId);

  @override
  List<Object?> get props => [...super.props, spaceId, spaceName, itemsCount];
}

class ItemLocationEntity extends LocationEntity {
  final String spaceId;
  final String spaceName;
  final String storageId;
  final String storageName;
  final int quantity;

  const ItemLocationEntity({
    required super.id,
    required super.name,
    super.description,
    required this.spaceId,
    required this.spaceName,
    required this.storageId,
    required this.storageName,
    required this.quantity,
  }) : super(type: LocationType.item, parentId: storageId);

  @override
  List<Object?> get props => [
    ...super.props,
    spaceId,
    spaceName,
    storageId,
    storageName,
    quantity,
  ];
}
