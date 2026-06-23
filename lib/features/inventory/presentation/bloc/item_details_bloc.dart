import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/entities/item_entity.dart';
import 'item_details_event.dart';
import 'item_details_state.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  final InventoryRepository _repository;

  ItemDetailsBloc({required InventoryRepository repository})
      : _repository = repository,
        super(const ItemDetailsInitial()) {
    on<LoadItemDetails>(_onLoadItemDetails);
    on<RefreshItemDetails>(_onRefreshItemDetails);
  }

  Future<void> _onLoadItemDetails(
    LoadItemDetails event,
    Emitter<ItemDetailsState> emit,
  ) async {
    emit(const ItemDetailsLoading());

    try {
      // Use the new API endpoint to get item details
      final repositoryImpl = _repository as dynamic;
      final result = await repositoryImpl.getItemDetailsWithLocation(event.itemId);
      
      result.fold(
        (failure) => emit(ItemDetailsError(message: failure.message)),
        (itemData) {
          final item = itemData['item'] as ItemEntity;
          final locationPath = itemData['location_path'] as String? ?? '';
          final categories = (itemData['categories'] as List<dynamic>?)
                  ?.map((cat) => cat.toString())
                  .cast<String>()
                  .toList() ??
              <String>[];
          final spaceId = itemData['space_id'] as String? ?? '';
          final spaceName = itemData['space_name'] as String? ?? '';
          final storageId = itemData['storage_id'] as String? ?? '';
          final storageName = itemData['storage_name'] as String? ?? '';

          emit(
            ItemDetailsLoaded(
              item: item,
              locationPath: locationPath,
              spaceId: spaceId,
              storageId: storageId,
              spaceName: spaceName,
              storageName: storageName,
              categories: categories,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        ItemDetailsError(
          message: 'Failed to load item details: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshItemDetails(
    RefreshItemDetails event,
    Emitter<ItemDetailsState> emit,
  ) async {
    add(
      LoadItemDetails(
        itemId: event.itemId,
        storageId: event.storageId,
        spaceId: event.spaceId,
        spaceName: event.spaceName,
        storageName: event.storageName,
      ),
    );
  }
}

