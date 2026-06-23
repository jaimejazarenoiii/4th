import 'package:equatable/equatable.dart';
import '../../domain/entities/storage_entity.dart';
import '../../domain/entities/item_entity.dart';

abstract class StorageDetailsState extends Equatable {
  const StorageDetailsState();

  @override
  List<Object?> get props => [];
}

class StorageDetailsInitial extends StorageDetailsState {
  const StorageDetailsInitial();
}

class StorageDetailsLoading extends StorageDetailsState {
  const StorageDetailsLoading();
}

class StorageDetailsLoaded extends StorageDetailsState {
  final StorageEntity storage;
  final List<StorageEntity> subStorages;
  final List<ItemEntity> items;
  final int currentSubStoragePage;
  final int currentItemPage;
  final bool hasMoreSubStorages;
  final bool hasMoreItems;
  final bool isLoadingSubStorages;
  final bool isLoadingItems;

  const StorageDetailsLoaded({
    required this.storage,
    required this.subStorages,
    required this.items,
    this.currentSubStoragePage = 1,
    this.currentItemPage = 1,
    this.hasMoreSubStorages = false,
    this.hasMoreItems = false,
    this.isLoadingSubStorages = false,
    this.isLoadingItems = false,
  });

  @override
  List<Object?> get props => [
    storage,
    subStorages,
    items,
    currentSubStoragePage,
    currentItemPage,
    hasMoreSubStorages,
    hasMoreItems,
    isLoadingSubStorages,
    isLoadingItems,
  ];

  StorageDetailsLoaded copyWith({
    StorageEntity? storage,
    List<StorageEntity>? subStorages,
    List<ItemEntity>? items,
    int? currentSubStoragePage,
    int? currentItemPage,
    bool? hasMoreSubStorages,
    bool? hasMoreItems,
    bool? isLoadingSubStorages,
    bool? isLoadingItems,
  }) {
    return StorageDetailsLoaded(
      storage: storage ?? this.storage,
      subStorages: subStorages ?? this.subStorages,
      items: items ?? this.items,
      currentSubStoragePage:
          currentSubStoragePage ?? this.currentSubStoragePage,
      currentItemPage: currentItemPage ?? this.currentItemPage,
      hasMoreSubStorages: hasMoreSubStorages ?? this.hasMoreSubStorages,
      hasMoreItems: hasMoreItems ?? this.hasMoreItems,
      isLoadingSubStorages: isLoadingSubStorages ?? this.isLoadingSubStorages,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
    );
  }
}

class StorageDetailsError extends StorageDetailsState {
  final String message;

  const StorageDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
