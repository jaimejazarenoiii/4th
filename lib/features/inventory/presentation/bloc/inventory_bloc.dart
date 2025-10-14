import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_spaces.dart';
import '../../domain/usecases/add_space.dart';
import '../../domain/usecases/update_space.dart';
import '../../domain/usecases/delete_space.dart';
import '../../domain/usecases/storage_usecases.dart';
import '../../domain/usecases/item_usecases.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetSpaces getSpaces;
  final AddSpace addSpace;
  final UpdateSpace updateSpace;
  final DeleteSpace deleteSpace;
  final AddStorage addStorage;
  final UpdateStorage updateStorage;
  final DeleteStorage deleteStorage;
  final AddItem addItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;

  InventoryBloc({
    required this.getSpaces,
    required this.addSpace,
    required this.updateSpace,
    required this.deleteSpace,
    required this.addStorage,
    required this.updateStorage,
    required this.deleteStorage,
    required this.addItem,
    required this.updateItem,
    required this.deleteItem,
  }) : super(InventoryInitial()) {
    on<LoadSpacesEvent>(_onLoadSpaces);
    on<AddSpaceEvent>(_onAddSpace);
    on<UpdateSpaceEvent>(_onUpdateSpace);
    on<DeleteSpaceEvent>(_onDeleteSpace);
    on<AddStorageEvent>(_onAddStorage);
    on<UpdateStorageEvent>(_onUpdateStorage);
    on<DeleteStorageEvent>(_onDeleteStorage);
    on<AddItemEvent>(_onAddItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
  }

  Future<void> _onLoadSpaces(
    LoadSpacesEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());
    final result = await getSpaces(const NoParams());
    result.fold(
      (failure) => emit(const InventoryError(message: 'Failed to load spaces')),
      (spaces) => emit(InventoryLoaded(spaces: spaces)),
    );
  }

  Future<void> _onAddSpace(
    AddSpaceEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await addSpace(
      AddSpaceParams(name: event.name, description: event.description),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to add space')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onUpdateSpace(
    UpdateSpaceEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await updateSpace(
      UpdateSpaceParams(
        id: event.id,
        name: event.name,
        description: event.description,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to update space')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onDeleteSpace(
    DeleteSpaceEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await deleteSpace(DeleteSpaceParams(id: event.id));
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to delete space')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onAddStorage(
    AddStorageEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await addStorage(
      AddStorageParams(
        spaceId: event.spaceId,
        name: event.name,
        description: event.description,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to add storage')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onUpdateStorage(
    UpdateStorageEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await updateStorage(
      UpdateStorageParams(
        spaceId: event.spaceId,
        storageId: event.storageId,
        name: event.name,
        description: event.description,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to update storage')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onDeleteStorage(
    DeleteStorageEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await deleteStorage(
      DeleteStorageParams(
        spaceId: event.spaceId,
        storageId: event.storageId,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to delete storage')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onAddItem(
    AddItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await addItem(
      AddItemParams(
        spaceId: event.spaceId,
        storageId: event.storageId,
        name: event.name,
        description: event.description,
        quantity: event.quantity,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to add item')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await updateItem(
      UpdateItemParams(
        spaceId: event.spaceId,
        storageId: event.storageId,
        itemId: event.itemId,
        name: event.name,
        description: event.description,
        quantity: event.quantity,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to update item')),
      (_) async => add(LoadSpacesEvent()),
    );
  }

  Future<void> _onDeleteItem(
    DeleteItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await deleteItem(
      DeleteItemParams(
        spaceId: event.spaceId,
        storageId: event.storageId,
        itemId: event.itemId,
      ),
    );
    await result.fold(
      (failure) async => emit(const InventoryError(message: 'Failed to delete item')),
      (_) async => add(LoadSpacesEvent()),
    );
  }
}

