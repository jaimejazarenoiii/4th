import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/inventory_repository.dart';
import 'storage_details_event.dart';
import 'storage_details_state.dart';

class StorageDetailsBloc
    extends Bloc<StorageDetailsEvent, StorageDetailsState> {
  final InventoryRepository _repository;

  StorageDetailsBloc({required InventoryRepository repository})
    : _repository = repository,
      super(const StorageDetailsInitial()) {
    on<LoadStorageDetails>(_onLoadStorageDetails);
    on<LoadSubStorages>(_onLoadSubStorages);
    on<LoadItems>(_onLoadItems);
    on<RefreshStorageDetails>(_onRefreshStorageDetails);
  }

  Future<void> _onLoadStorageDetails(
    LoadStorageDetails event,
    Emitter<StorageDetailsState> emit,
  ) async {
    emit(const StorageDetailsLoading());

    try {
      // Load storage details with children and items
      final result = await _repository.getStorageDetails(event.storageId);
      result.fold(
        (failure) => emit(StorageDetailsError(message: failure.message)),
        (storage) {
          emit(
            StorageDetailsLoaded(
              storage: storage,
              subStorages: storage.children,
              items: storage.items,
              hasMoreSubStorages:
                  storage.childrenCount > storage.children.length,
              hasMoreItems: storage.itemsCount > storage.items.length,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        StorageDetailsError(
          message: 'Failed to load storage details: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadSubStorages(
    LoadSubStorages event,
    Emitter<StorageDetailsState> emit,
  ) async {
    if (state is! StorageDetailsLoaded) return;

    final currentState = state as StorageDetailsLoaded;
    emit(currentState.copyWith(isLoadingSubStorages: true));

    try {
      final result = await _repository.getSubStorages(
        event.storageId,
        page: event.loadAll ? null : event.page,
      );

      result.fold(
        (failure) => emit(StorageDetailsError(message: failure.message)),
        (newSubStorages) {
          final updatedSubStorages = event.page == 1 || event.loadAll
              ? newSubStorages
              : [...currentState.subStorages, ...newSubStorages];

          emit(
            currentState.copyWith(
              subStorages: updatedSubStorages,
              currentSubStoragePage: event.loadAll ? 1 : event.page,
              hasMoreSubStorages: !event.loadAll && newSubStorages.length >= 10,
              isLoadingSubStorages: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        StorageDetailsError(
          message: 'Failed to load sub-storages: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<StorageDetailsState> emit,
  ) async {
    if (state is! StorageDetailsLoaded) return;

    final currentState = state as StorageDetailsLoaded;
    emit(currentState.copyWith(isLoadingItems: true));

    try {
      final result = await _repository.getItemsForStorage(
        event.storageId,
        page: event.page,
      );

      result.fold(
        (failure) => emit(StorageDetailsError(message: failure.message)),
        (newItems) {
          final updatedItems = event.page == 1
              ? newItems
              : [...currentState.items, ...newItems];

          emit(
            currentState.copyWith(
              items: updatedItems,
              currentItemPage: event.page,
              hasMoreItems: newItems.length >= 10,
              isLoadingItems: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        StorageDetailsError(message: 'Failed to load items: ${e.toString()}'),
      );
    }
  }

  Future<void> _onRefreshStorageDetails(
    RefreshStorageDetails event,
    Emitter<StorageDetailsState> emit,
  ) async {
    add(LoadStorageDetails(storageId: event.storageId));
  }
}
