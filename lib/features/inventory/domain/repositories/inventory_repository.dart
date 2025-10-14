import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/space_entity.dart';

abstract class InventoryRepository {
  // Spaces
  Future<Either<Failure, List<SpaceEntity>>> getSpaces();
  Future<Either<Failure, void>> addSpace(String name, String? description);
  Future<Either<Failure, void>> updateSpace(String id, String name, String? description);
  Future<Either<Failure, void>> deleteSpace(String id);
  
  // Storages
  Future<Either<Failure, void>> addStorage(String spaceId, String name, String? description);
  Future<Either<Failure, void>> updateStorage(String spaceId, String storageId, String name, String? description);
  Future<Either<Failure, void>> deleteStorage(String spaceId, String storageId);
  
  // Items
  Future<Either<Failure, void>> addItem(String spaceId, String storageId, String name, String? description, int? quantity);
  Future<Either<Failure, void>> updateItem(String spaceId, String storageId, String itemId, String name, String? description, int? quantity);
  Future<Either<Failure, void>> deleteItem(String spaceId, String storageId, String itemId);
}

