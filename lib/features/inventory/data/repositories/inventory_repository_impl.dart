import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/space_entity.dart';
import '../../domain/entities/storage_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/entities/browse_node.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../datasources/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

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
  Future<Either<Failure, void>> addSpace(
    String name,
    String? description,
    File? image,
  ) async {
    try {
      // First, create the space via API
      await remoteDataSource.createSpace(name, description, image);

      // Then, save it locally for offline access
      await localDataSource.addSpace(name, description, image);

      return const Right(null);
    } on DioException catch (e) {
      return Left(
        _mapDioExceptionToFailure(
          e,
          fallbackMessage: 'Failed to add space',
          resourceHint: 'spaces',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to add space: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSpace(
    String id,
    String name,
    String? description,
  ) async {
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
  Future<Either<Failure, List<StorageEntity>>> getStoragesForSpace(
    String spaceId,
  ) async {
    try {
      final spaces = await localDataSource.getSpaces();
      final space = spaces.firstWhere(
        (space) => space.id == spaceId,
        orElse: () => throw Exception('Space not found'),
      );
      return Right(space.storages);
    } catch (e) {
      return Left(CacheFailure('Failed to load storages: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, StorageEntity>> getStorageDetails(
    String storageId,
  ) async {
    try {
      final resp = await remoteDataSource.getStorageDetails(storageId);
      return Right(resp);
    } catch (e) {
      return Left(
        ServerFailure('Failed to load storage details: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<StorageEntity>>> getSubStorages(
    String parentStorageId, {
    int? page,
  }) async {
    try {
      // For now, return empty list as we don't have sub-storage implementation yet
      // This would be implemented with proper API calls
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure('Failed to load sub-storages: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsForStorage(
    String storageId, {
    int? page,
  }) async {
    try {
      final spaces = await localDataSource.getSpaces();
      for (final space in spaces) {
        for (final storage in space.storages) {
          if (storage.id == storageId) {
            // Simple pagination - return 10 items per page
            final items = storage.items;
            if (page != null) {
              final startIndex = (page - 1) * 10;
              final endIndex = (startIndex + 10).clamp(0, items.length);
              return Right(items.sublist(startIndex, endIndex));
            }
            return Right(items);
          }
        }
      }
      throw Exception('Storage not found');
    } catch (e) {
      return Left(CacheFailure('Failed to load items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemDetails(String itemId) async {
    try {
      final itemData = await remoteDataSource.getItemDetailsWithLocation(itemId);
      return Right(itemData['item'] as ItemEntity);
    } catch (e) {
      return Left(
        ServerFailure('Failed to load item details: ${e.toString()}'),
      );
    }
  }

  /// Get item details with location and categories
  Future<Either<Failure, Map<String, dynamic>>> getItemDetailsWithLocation(
      String itemId) async {
    try {
      final itemData = await remoteDataSource.getItemDetailsWithLocation(itemId);
      return Right(itemData);
    } catch (e) {
      return Left(
        ServerFailure('Failed to load item details: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addStorage(
    String name,
    String? description,
    String spaceId,
    String? parentStorageId,
    File? image,
  ) async {
    try {
      // First, create the storage via API
      await remoteDataSource.createStorage(
        name,
        description,
        spaceId,
        parentStorageId,
        image,
      );

      // Then, save it locally for offline access
      await localDataSource.addStorage(spaceId, name, description);

      return const Right(null);
    } on DioException catch (e) {
      return Left(
        _mapDioExceptionToFailure(
          e,
          fallbackMessage: 'Failed to add storage',
          resourceHint: 'storages',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to add storage: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStorage(
    String spaceId,
    String storageId,
    String name,
    String? description,
  ) async {
    try {
      await localDataSource.updateStorage(
        spaceId,
        storageId,
        name,
        description,
      );
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update storage'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStorage(
    String spaceId,
    String storageId,
  ) async {
    try {
      await localDataSource.deleteStorage(spaceId, storageId);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to delete storage'));
    }
  }

  @override
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
  ) async {
    try {
      // First, create the item via API
      await remoteDataSource.createItem(
        spaceId,
        storageId,
        name,
        description,
        quantity,
        expiryDate,
        unit,
        categoryIds,
        image,
      );

      // Then, save it locally for offline access (without categories for now)
      await localDataSource.addItem(
        spaceId,
        storageId,
        name,
        description,
        quantity,
      );

      return const Right(null);
    } on DioException catch (e) {
      return Left(
        _mapDioExceptionToFailure(
          e,
          fallbackMessage: 'Failed to add item',
          resourceHint: 'items',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to add item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(
    String spaceId,
    String storageId,
    String itemId,
    String name,
    String? description,
    int? quantity,
  ) async {
    try {
      await localDataSource.updateItem(
        spaceId,
        storageId,
        itemId,
        name,
        description,
        quantity,
      );
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update item'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(
    String spaceId,
    String storageId,
    String itemId,
  ) async {
    try {
      await localDataSource.deleteItem(spaceId, storageId, itemId);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to delete item'));
    }
  }

  // Browse APIs
  @override
  Future<Either<Failure, List<BrowseNode>>> browseSpaces() async {
    try {
      final resp = await remoteDataSource.browseSpaces();
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure('Failed to browse spaces: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<BrowseNode>>> browseStorages({
    String? spaceId,
    String? parentId,
  }) async {
    try {
      final resp = await remoteDataSource.browseStorages(
        spaceId: spaceId,
        parentId: parentId,
      );
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure('Failed to browse storages: ${e.toString()}'));
    }
  }

  // Categories
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(
        ServerFailure('Failed to load categories: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory(String name) async {
    try {
      final category = await remoteDataSource.createCategory(name);
      return Right(category);
    } catch (e) {
      return Left(
        ServerFailure('Failed to create category: ${e.toString()}'),
      );
    }
  }

  Failure _mapDioExceptionToFailure(
    DioException exception, {
    required String fallbackMessage,
    String? resourceHint,
  }) {
    final statusCode = exception.response?.statusCode;
    final inferredResource = _inferResourceFromPath(
      exception.requestOptions.path,
      hint: resourceHint,
    );

    if (statusCode == 403) {
      final message =
          _extractErrorMessage(exception) ?? 'Plan limit reached for $inferredResource.';
      final limit = _extractLimit(message);

      return PlanLimitFailure(
        message: message,
        resource: inferredResource,
        limit: limit,
      );
    }

    final message =
        _extractErrorMessage(exception) ?? exception.message ?? 'Unknown error';
    return ServerFailure('$fallbackMessage: $message');
  }

  String _inferResourceFromPath(
    String path, {
    String? hint,
  }) {
    if (hint != null && hint.isNotEmpty) {
      return hint;
    }

    final normalized = path.toLowerCase();
    if (normalized.contains('spaces')) return 'spaces';
    if (normalized.contains('storages')) return 'storages';
    if (normalized.contains('items')) return 'items';
    return 'resources';
  }

  String? _extractErrorMessage(DioException exception) {
    final data = exception.response?.data;

    if (data is Map) {
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is String && first.isNotEmpty) {
          return first;
        }
        if (first != null) {
          return first.toString();
        }
        return null;
      }

      final status = data['status'];
      if (status is Map) {
        final statusMessage = status['message'];
        if (statusMessage is String && statusMessage.isNotEmpty) {
          return statusMessage;
        }
      }

      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    } else if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
      if (first != null) {
        return first.toString();
      }
      return null;
    } else if (data is String && data.isNotEmpty) {
      return data;
    }

    return exception.message;
  }

  int? _extractLimit(String message) {
    final match = RegExp(r'\b(\d+)\b').firstMatch(message);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }
}
