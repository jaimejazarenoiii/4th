import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/space_model.dart';
import '../models/storage_model.dart';
import '../models/item_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<SpaceModel>> getSpaces();
  Future<void> saveSpaces(List<SpaceModel> spaces);
  Future<void> addSpace(String name, String? description);
  Future<void> updateSpace(String id, String name, String? description);
  Future<void> deleteSpace(String id);
  Future<void> addStorage(String spaceId, String name, String? description);
  Future<void> updateStorage(String spaceId, String storageId, String name, String? description);
  Future<void> deleteStorage(String spaceId, String storageId);
  Future<void> addItem(String spaceId, String storageId, String name, String? description, int? quantity);
  Future<void> updateItem(String spaceId, String storageId, String itemId, String name, String? description, int? quantity);
  Future<void> deleteItem(String spaceId, String storageId, String itemId);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Uuid uuid;
  static const String cachedSpacesKey = 'CACHED_SPACES';

  InventoryLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.uuid,
  });

  @override
  Future<List<SpaceModel>> getSpaces() async {
    final jsonString = sharedPreferences.getString(cachedSpacesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => SpaceModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> saveSpaces(List<SpaceModel> spaces) async {
    final String jsonString = json.encode(
      spaces.map((space) => space.toJson()).toList(),
    );
    await sharedPreferences.setString(cachedSpacesKey, jsonString);
  }

  @override
  Future<void> addSpace(String name, String? description) async {
    final spaces = await getSpaces();
    final now = DateTime.now();
    final newSpace = SpaceModel(
      id: uuid.v4(),
      name: name,
      description: description,
      storages: const [],
      createdAt: now,
      updatedAt: now,
    );
    spaces.add(newSpace);
    await saveSpaces(spaces);
  }

  @override
  Future<void> updateSpace(String id, String name, String? description) async {
    final spaces = await getSpaces();
    final index = spaces.indexWhere((s) => s.id == id);
    if (index != -1) {
      spaces[index] = spaces[index].copyWith(
        name: name,
        description: description,
        updatedAt: DateTime.now(),
      );
      await saveSpaces(spaces);
    }
  }

  @override
  Future<void> deleteSpace(String id) async {
    final spaces = await getSpaces();
    spaces.removeWhere((s) => s.id == id);
    await saveSpaces(spaces);
  }

  @override
  Future<void> addStorage(String spaceId, String name, String? description) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final now = DateTime.now();
      final newStorage = StorageModel(
        id: uuid.v4(),
        name: name,
        description: description,
        items: const [],
        createdAt: now,
        updatedAt: now,
      );
      final updatedStorages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      )..add(newStorage);
      
      spaces[spaceIndex] = spaces[spaceIndex].copyWith(
        storages: updatedStorages,
        updatedAt: now,
      );
      await saveSpaces(spaces);
    }
  }

  @override
  Future<void> updateStorage(String spaceId, String storageId, String name, String? description) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final storages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      );
      final storageIndex = storages.indexWhere((st) => st.id == storageId);
      if (storageIndex != -1) {
        final now = DateTime.now();
        storages[storageIndex] = storages[storageIndex].copyWith(
          name: name,
          description: description,
          updatedAt: now,
        );
        spaces[spaceIndex] = spaces[spaceIndex].copyWith(
          storages: storages,
          updatedAt: now,
        );
        await saveSpaces(spaces);
      }
    }
  }

  @override
  Future<void> deleteStorage(String spaceId, String storageId) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final updatedStorages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      )..removeWhere((st) => st.id == storageId);
      
      spaces[spaceIndex] = spaces[spaceIndex].copyWith(
        storages: updatedStorages,
        updatedAt: DateTime.now(),
      );
      await saveSpaces(spaces);
    }
  }

  @override
  Future<void> addItem(String spaceId, String storageId, String name, String? description, int? quantity) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final storages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      );
      final storageIndex = storages.indexWhere((st) => st.id == storageId);
      if (storageIndex != -1) {
        final now = DateTime.now();
        final newItem = ItemModel(
          id: uuid.v4(),
          name: name,
          description: description,
          quantity: quantity,
          createdAt: now,
          updatedAt: now,
        );
        final updatedItems = List<ItemModel>.from(
          storages[storageIndex].items.map((i) => i as ItemModel),
        )..add(newItem);
        
        storages[storageIndex] = storages[storageIndex].copyWith(
          items: updatedItems,
          updatedAt: now,
        );
        spaces[spaceIndex] = spaces[spaceIndex].copyWith(
          storages: storages,
          updatedAt: now,
        );
        await saveSpaces(spaces);
      }
    }
  }

  @override
  Future<void> updateItem(String spaceId, String storageId, String itemId, String name, String? description, int? quantity) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final storages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      );
      final storageIndex = storages.indexWhere((st) => st.id == storageId);
      if (storageIndex != -1) {
        final items = List<ItemModel>.from(
          storages[storageIndex].items.map((i) => i as ItemModel),
        );
        final itemIndex = items.indexWhere((i) => i.id == itemId);
        if (itemIndex != -1) {
          final now = DateTime.now();
          items[itemIndex] = items[itemIndex].copyWith(
            name: name,
            description: description,
            quantity: quantity,
            updatedAt: now,
          );
          storages[storageIndex] = storages[storageIndex].copyWith(
            items: items,
            updatedAt: now,
          );
          spaces[spaceIndex] = spaces[spaceIndex].copyWith(
            storages: storages,
            updatedAt: now,
          );
          await saveSpaces(spaces);
        }
      }
    }
  }

  @override
  Future<void> deleteItem(String spaceId, String storageId, String itemId) async {
    final spaces = await getSpaces();
    final spaceIndex = spaces.indexWhere((s) => s.id == spaceId);
    if (spaceIndex != -1) {
      final storages = List<StorageModel>.from(
        spaces[spaceIndex].storages.map((s) => s as StorageModel),
      );
      final storageIndex = storages.indexWhere((st) => st.id == storageId);
      if (storageIndex != -1) {
        final updatedItems = List<ItemModel>.from(
          storages[storageIndex].items.map((i) => i as ItemModel),
        )..removeWhere((i) => i.id == itemId);
        
        final now = DateTime.now();
        storages[storageIndex] = storages[storageIndex].copyWith(
          items: updatedItems,
          updatedAt: now,
        );
        spaces[spaceIndex] = spaces[spaceIndex].copyWith(
          storages: storages,
          updatedAt: now,
        );
        await saveSpaces(spaces);
      }
    }
  }
}

