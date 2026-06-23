import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import 'location_selection_event.dart';
import 'location_selection_state.dart';

class LocationSelectionBloc
    extends Bloc<LocationSelectionEvent, LocationSelectionState> {
  final InventoryRepository _repository;

  LocationSelectionBloc({required InventoryRepository repository})
    : _repository = repository,
      super(const LocationSelectionInitial()) {
    on<LoadSpaces>(_onLoadSpaces);
    on<LoadStoragesForSpace>(_onLoadStoragesForSpace);
    on<LoadItemsForStorage>(_onLoadItemsForStorage);
    on<LoadChildStorages>(_onLoadChildStorages);
    on<SelectLocation>(_onSelectLocation);
    on<HighlightLocation>(_onHighlightLocation);
    on<NavigateBack>(_onNavigateBack);
    on<ResetLocationSelection>(_onResetLocationSelection);
  }

  Future<void> _onLoadSpaces(
    LoadSpaces event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(const LocationSelectionLoading());

    try {
      final result = await _repository.browseSpaces();
      result.fold(
        (failure) => emit(LocationSelectionError(message: failure.message)),
        (spaces) {
          final locations = spaces
              .map(
                (node) => SpaceLocationEntity(
                  id: node.id,
                  name: node.name,
                  description: null,
                  storagesCount: node.childrenCount ?? 0,
                  itemsCount: 0,
                ),
              )
              .toList();

          emit(
            LocationSelectionLoaded(
              locations: locations,
              currentPath: 'Spaces',
              selectedLocationId: null,
              selectedLocationName: null,
              selectedLocationPath: null,
              selectedLocationType: null,
              selectedSpaceId: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        LocationSelectionError(
          message: 'Failed to load spaces: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadStoragesForSpace(
    LoadStoragesForSpace event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(const LocationSelectionLoading());

    try {
      final result = await _repository.browseStorages(spaceId: event.spaceId);
      result.fold(
        (failure) => emit(LocationSelectionError(message: failure.message)),
        (storages) {
          final locations = storages
              .map(
                (node) => StorageLocationEntity(
                  id: node.id,
                  name: node.name,
                  description: null,
                  spaceId: event.spaceId,
                  spaceName: event.spaceName,
                  itemsCount: node.childrenCount ?? 0,
                ),
              )
              .toList();

          emit(
            LocationSelectionLoaded(
              locations: locations,
              currentPath: '${event.spaceName} > Storages',
              selectedLocationId: null,
              selectedLocationName: null,
              selectedLocationPath: null,
              selectedLocationType: null,
              selectedSpaceId: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        LocationSelectionError(
          message: 'Failed to load storages: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLoadItemsForStorage(
    LoadItemsForStorage event,
    Emitter<LocationSelectionState> emit,
  ) async {
    // Switch to browse child storages instead of items for location picking
    // because move/create targets are storages (leaf)
    add(
      LoadChildStorages(
        parentStorageId: event.storageId,
        parentStorageName: event.storageName,
        spaceId: event.spaceId,
        spaceName: event.spaceName,
      ),
    );
  }

  Future<void> _onLoadChildStorages(
    LoadChildStorages event,
    Emitter<LocationSelectionState> emit,
  ) async {
    emit(const LocationSelectionLoading());
    try {
      final result = await _repository.browseStorages(
        parentId: event.parentStorageId,
      );
      result.fold(
        (failure) => emit(LocationSelectionError(message: failure.message)),
        (storages) {
          final locations = storages
              .map(
                (node) => StorageLocationEntity(
                  id: node.id,
                  name: node.name,
                  description: null,
                  spaceId: event.spaceId,
                  spaceName: event.spaceName,
                  itemsCount: node.childrenCount ?? 0,
                ),
              )
              .toList();

          emit(
            LocationSelectionLoaded(
              locations: locations,
              currentPath: '${event.spaceName} > ${event.parentStorageName}',
              selectedLocationId: null,
              selectedLocationName: null,
              selectedLocationPath: null,
              selectedLocationType: null,
              selectedSpaceId: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        LocationSelectionError(
          message: 'Failed to load child storages: ${e.toString()}',
        ),
      );
    }
  }

  void _onSelectLocation(
    SelectLocation event,
    Emitter<LocationSelectionState> emit,
  ) {
    emit(
      LocationSelected(
        locationId: event.locationId,
        locationName: event.locationName,
        locationPath: event.locationPath,
        locationType: event.locationType,
        spaceId: event.spaceId,
      ),
    );
  }

  void _onHighlightLocation(
    HighlightLocation event,
    Emitter<LocationSelectionState> emit,
  ) {
    final currentState = state;
    if (currentState is LocationSelectionLoaded) {
      emit(
        LocationSelectionLoaded(
          locations: currentState.locations,
          currentPath: currentState.currentPath,
          selectedLocationId: event.locationId,
          selectedLocationName: event.locationName,
          selectedLocationPath: event.locationPath,
          selectedLocationType: event.locationType,
          selectedSpaceId: event.spaceId,
        ),
      );
    }
  }

  void _onNavigateBack(
    NavigateBack event,
    Emitter<LocationSelectionState> emit,
  ) {
    // This will be handled by the UI layer
    // The bloc doesn't need to track navigation history
  }

  void _onResetLocationSelection(
    ResetLocationSelection event,
    Emitter<LocationSelectionState> emit,
  ) {
    emit(const LocationSelectionInitial());
  }
}
