import 'package:equatable/equatable.dart';

abstract class ItemDetailsEvent extends Equatable {
  const ItemDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemDetails extends ItemDetailsEvent {
  final String itemId;
  final String? storageId; // Optional: if provided, fetch from this storage
  final String? spaceId;
  final String? spaceName;
  final String? storageName;

  const LoadItemDetails({
    required this.itemId,
    this.storageId,
    this.spaceId,
    this.spaceName,
    this.storageName,
  });

  @override
  List<Object?> get props => [itemId, storageId, spaceId, spaceName, storageName];
}

class RefreshItemDetails extends ItemDetailsEvent {
  final String itemId;
  final String? storageId;
  final String? spaceId;
  final String? spaceName;
  final String? storageName;

  const RefreshItemDetails({
    required this.itemId,
    this.storageId,
    this.spaceId,
    this.spaceName,
    this.storageName,
  });

  @override
  List<Object?> get props => [
        itemId,
        storageId,
        spaceId,
        spaceName,
        storageName,
      ];
}

