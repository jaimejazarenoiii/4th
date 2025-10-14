import 'package:equatable/equatable.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

// Load Spaces
class LoadSpacesEvent extends InventoryEvent {}

// Space Events
class AddSpaceEvent extends InventoryEvent {
  final String name;
  final String? description;

  const AddSpaceEvent({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class UpdateSpaceEvent extends InventoryEvent {
  final String id;
  final String name;
  final String? description;

  const UpdateSpaceEvent({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

class DeleteSpaceEvent extends InventoryEvent {
  final String id;

  const DeleteSpaceEvent({required this.id});

  @override
  List<Object> get props => [id];
}

// Storage Events
class AddStorageEvent extends InventoryEvent {
  final String spaceId;
  final String name;
  final String? description;

  const AddStorageEvent({
    required this.spaceId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [spaceId, name, description];
}

class UpdateStorageEvent extends InventoryEvent {
  final String spaceId;
  final String storageId;
  final String name;
  final String? description;

  const UpdateStorageEvent({
    required this.spaceId,
    required this.storageId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [spaceId, storageId, name, description];
}

class DeleteStorageEvent extends InventoryEvent {
  final String spaceId;
  final String storageId;

  const DeleteStorageEvent({
    required this.spaceId,
    required this.storageId,
  });

  @override
  List<Object> get props => [spaceId, storageId];
}

// Item Events
class AddItemEvent extends InventoryEvent {
  final String spaceId;
  final String storageId;
  final String name;
  final String? description;
  final int? quantity;

  const AddItemEvent({
    required this.spaceId,
    required this.storageId,
    required this.name,
    this.description,
    this.quantity,
  });

  @override
  List<Object?> get props => [spaceId, storageId, name, description, quantity];
}

class UpdateItemEvent extends InventoryEvent {
  final String spaceId;
  final String storageId;
  final String itemId;
  final String name;
  final String? description;
  final int? quantity;

  const UpdateItemEvent({
    required this.spaceId,
    required this.storageId,
    required this.itemId,
    required this.name,
    this.description,
    this.quantity,
  });

  @override
  List<Object?> get props => [spaceId, storageId, itemId, name, description, quantity];
}

class DeleteItemEvent extends InventoryEvent {
  final String spaceId;
  final String storageId;
  final String itemId;

  const DeleteItemEvent({
    required this.spaceId,
    required this.storageId,
    required this.itemId,
  });

  @override
  List<Object> get props => [spaceId, storageId, itemId];
}

