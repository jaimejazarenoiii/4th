import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<SpaceEntity>>> getSpaces() async {
    try {
      final spaces = await localDataSource.getSpaces();
      return Right(spaces);
    } catch (e) {
      return const Left(CacheFailure('Failed to load spaces'));
    }
  }

  @override
  Future<Either<Failure, void>> addSpace(String name, String? description) async {
    try {
      await localDataSource.addSpace(name, description);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to add space'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSpace(String id, String name, String? description) async {
    try {
      await localDataSource.updateSpace(id, name, description);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update space'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSpace(String id) async {
    try {
      await localDataSource.deleteSpace(id);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to delete space'));
    }
  }

  @override
  Future<Either<Failure, void>> addStorage(String spaceId, String name, String? description) async {
    try {
      await localDataSource.addStorage(spaceId, name, description);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to add storage'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStorage(String spaceId, String storageId, String name, String? description) async {
    try {
      await localDataSource.updateStorage(spaceId, storageId, name, description);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update storage'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStorage(String spaceId, String storageId) async {
    try {
      await localDataSource.deleteStorage(spaceId, storageId);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to delete storage'));
    }
  }

  @override
  Future<Either<Failure, void>> addItem(String spaceId, String storageId, String name, String? description, int? quantity) async {
    try {
      await localDataSource.addItem(spaceId, storageId, name, description, quantity);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to add item'));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(String spaceId, String storageId, String itemId, String name, String? description, int? quantity) async {
    try {
      await localDataSource.updateItem(spaceId, storageId, itemId, name, description, quantity);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update item'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String spaceId, String storageId, String itemId) async {
    try {
      await localDataSource.deleteItem(spaceId, storageId, itemId);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to delete item'));
    }
  }
}

