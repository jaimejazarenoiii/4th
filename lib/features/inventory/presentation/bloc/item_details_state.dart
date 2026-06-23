import 'package:equatable/equatable.dart';
import '../../domain/entities/item_entity.dart';

abstract class ItemDetailsState extends Equatable {
  const ItemDetailsState();

  @override
  List<Object?> get props => [];
}

class ItemDetailsInitial extends ItemDetailsState {
  const ItemDetailsInitial();
}

class ItemDetailsLoading extends ItemDetailsState {
  const ItemDetailsLoading();
}

class ItemDetailsLoaded extends ItemDetailsState {
  final ItemEntity item;
  final String locationPath; // Format: "Space Name > Storage Name"
  final String spaceId;
  final String storageId;
  final String spaceName;
  final String storageName;
  final List<String> categories; // Category names

  const ItemDetailsLoaded({
    required this.item,
    required this.locationPath,
    required this.spaceId,
    required this.storageId,
    required this.spaceName,
    required this.storageName,
    this.categories = const [],
  });

  @override
  List<Object?> get props => [
        item,
        locationPath,
        spaceId,
        storageId,
        spaceName,
        storageName,
        categories,
      ];
}

class ItemDetailsError extends ItemDetailsState {
  final String message;

  const ItemDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

