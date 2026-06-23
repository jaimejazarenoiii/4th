import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/browse_node.dart';
import '../entities/space_entity.dart';
import '../entities/storage_entity.dart';
import '../entities/item_entity.dart';
import '../entities/category_entity.dart';

abstract class InventoryRepository {
  // Spaces
  Future<Either<Failure, List<SpaceEntity>>> getSpaces();
  Future<Either<Failure, void>> addSpace(
    String name,
    String? description,
    File? image,
  );
  Future<Either<Failure, void>> updateSpace(
    String id,
    String name,
    String? description,
  );
  Future<Either<Failure, void>> deleteSpace(String id);

  // Storages
  Future<Either<Failure, List<StorageEntity>>> getStoragesForSpace(
    String spaceId,
  );
  Future<Either<Failure, StorageEntity>> getStorageDetails(String storageId);
  Future<Either<Failure, List<StorageEntity>>> getSubStorages(
    String parentStorageId, {
    int? page,
  });
  Future<Either<Failure, void>> addStorage(
    String name,
    String? description,
    String spaceId,
    String? parentStorageId,
    File? image,
  );
  Future<Either<Failure, void>> updateStorage(
    String spaceId,
    String storageId,
    String name,
    String? description,
  );
  Future<Either<Failure, void>> deleteStorage(String spaceId, String storageId);

  // Items
  Future<Either<Failure, List<ItemEntity>>> getItemsForStorage(
    String storageId, {
    int? page,
  });
  Future<Either<Failure, ItemEntity>> getItemDetails(String itemId);
  Future<Either<Failure, void>> addItem(
    String spaceId,
    String storageId,
    String name,
    String? description,
    int? quantity,
    String? expiryDate,
    String? unit,
    List<int>? categoryIds,
    File? image,
  );
  Future<Either<Failure, void>> updateItem(
    String spaceId,
    String storageId,
    String itemId,
    String name,
    String? description,
    int? quantity,
  );
  Future<Either<Failure, void>> deleteItem(
    String spaceId,
    String storageId,
    String itemId,
  );

  // Browse (spaces -> storages -> child storages)
  Future<Either<Failure, List<BrowseNode>>> browseSpaces();
  Future<Either<Failure, List<BrowseNode>>> browseStorages({
    String? spaceId,
    String? parentId,
  });

  // Categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> createCategory(String name);
}
