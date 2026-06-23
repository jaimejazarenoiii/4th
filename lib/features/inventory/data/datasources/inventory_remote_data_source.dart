import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/space_model.dart';
import '../models/category_model.dart';
import '../../domain/entities/browse_node.dart';
import '../../domain/entities/storage_entity.dart';
import '../../domain/entities/item_entity.dart';

/// Abstract interface for remote data source
/// This will be used when you want to fetch data from the API instead of local storage
abstract class InventoryRemoteDataSource {
  Future<List<SpaceModel>> getSpaces();
  Future<SpaceModel> createSpace(String name, String? description, File? image);
  Future<SpaceModel> updateSpace(String id, String name, String? description);
  Future<void> deleteSpace(String id);
  Future<void> createStorage(
    String name,
    String? description,
    String spaceId,
    String? parentStorageId,
    File? image,
  );
  Future<StorageEntity> getStorageDetails(String storageId);
  // Browse
  Future<List<BrowseNode>> browseSpaces();
  Future<List<BrowseNode>> browseStorages({String? spaceId, String? parentId});
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory(String name);
  // Item details
  Future<ItemEntity> getItemDetails(String itemId);
  Future<Map<String, dynamic>> getItemDetailsWithLocation(String itemId);
  // Items
  Future<void> createItem(
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
  // Add more methods for storages and items as needed
}

/// Implementation of the remote data source using Dio
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final DioClient dioClient;

  InventoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SpaceModel>> getSpaces() async {
    try {
      final response = await dioClient.get(ApiConstants.spaces);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => SpaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load spaces',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<SpaceModel> createSpace(
    String name,
    String? description,
    File? image,
  ) async {
    try {
      FormData formData;

      if (image != null) {
        // Create FormData for file upload
        formData = FormData.fromMap({
          'space': {
            'name': name,
            'description': description ?? '',
            'image': await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          },
        });
      } else {
        // Create FormData without file
        formData = FormData.fromMap({
          'space': {'name': name, 'description': description ?? ''},
        });
      }

      final response = await dioClient.post(
        ApiConstants.spaces,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SpaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to create space',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<SpaceModel> updateSpace(
    String id,
    String name,
    String? description,
  ) async {
    try {
      final response = await dioClient.put(
        '${ApiConstants.spaces}/$id',
        data: {'name': name, 'description': description},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return SpaceModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to update space',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteSpace(String id) async {
    try {
      final response = await dioClient.delete('${ApiConstants.spaces}/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to delete space',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Example: Add methods for storages
  @override
  Future<void> createStorage(
    String name,
    String? description,
    String spaceId,
    String? parentStorageId,
    File? image,
  ) async {
    try {
      FormData formData;

      if (image != null) {
        // Create FormData for file upload
        formData = FormData.fromMap({
          'storage': {
            'name': name,
            'description': description ?? '',
            'parent_id': parentStorageId,
            'image': await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          },
        });
      } else {
        // Create FormData without file
        formData = FormData.fromMap({
          'storage': {
            'name': name,
            'description': description ?? '',
            'parent_id': parentStorageId,
          },
        });
      }

      // Always use the space endpoint for both parent and child storages
      final response = await dioClient.post(
        '${ApiConstants.spaces}/$spaceId/${ApiConstants.storages}',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to create storage',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Example: Add methods for items
  @override
  Future<void> createItem(
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
      FormData formData;
      final itemData = <String, dynamic>{
        'name': name,
        'storage_id': int.parse(storageId),
        if (description != null && description.isNotEmpty) 'notes': description,
        if (quantity != null) 'quantity': quantity,
        if (expiryDate != null && expiryDate.isNotEmpty)
          'expiration_date': expiryDate,
        if (unit != null && unit.isNotEmpty) 'unit': unit,
        if (categoryIds != null && categoryIds.isNotEmpty)
          'category_ids': categoryIds,
      };

      if (image != null) {
        formData = FormData.fromMap({
          'item': itemData,
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        });
      } else {
        formData = FormData.fromMap({
          'item': itemData,
        });
      }

      final response = await dioClient.post(
        ApiConstants.items,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to create item',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<StorageEntity> getStorageDetails(String storageId) async {
    final response = await dioClient.get('storages/$storageId');
    if (response.statusCode == 200) {
      final data = response.data['data']['storage'];
      final children = (data['children']['data'] as List<dynamic>)
          .map(
            (child) => StorageEntity(
              id: child['id'].toString(),
              name: child['name'] as String,
              description: child['description'] as String?,
              spaceId: child['space_id'].toString(),
              spaceName: child['space_name'] as String,
              parentId: child['parent_id']?.toString(),
              imageUrl: child['image_url'] as String?,
              childrenCount: child['children_count'] as int,
              itemsCount: child['items_count'] as int,
              children:
                  const [], // Children don't have nested children in this response
              items: const [], // Items are separate
              createdAt: DateTime.parse(child['created_at'] as String),
              updatedAt: DateTime.parse(child['updated_at'] as String),
            ),
          )
          .toList();

      // Helper function to parse quantity (handles both string and num)
      double parseQuantity(dynamic value) {
        if (value == null) return 0.0;
        if (value is num) return value.toDouble();
        if (value is String) {
          return double.tryParse(value) ?? 0.0;
        }
        return 0.0;
      }

      // Helper function to parse optional numeric fields
      double? parseOptionalDouble(dynamic value) {
        if (value == null) return null;
        if (value is num) return value.toDouble();
        if (value is String) {
          return double.tryParse(value);
        }
        return null;
      }

      final items = (data['items']['data'] as List<dynamic>)
          .map(
            (item) => ItemEntity(
              id: item['id'].toString(),
              name: item['name'] as String,
              quantity: parseQuantity(item['quantity']),
              unit: item['unit'] as String,
              minQuantity: parseOptionalDouble(item['min_quantity']),
              outOfStockThreshold: parseOptionalDouble(item['out_of_stock_threshold']),
              lowStockAlertEnabled: item['low_stock_alert_enabled'] as bool,
              outOfStockAlertEnabled:
                  item['out_of_stock_alert_enabled'] as bool,
              expirationDate: item['expiration_date'] as String?,
              notes: item['notes'] as String?,
              imageUrl: item['image_url'] as String?,
              lowStock: item['low_stock'] as bool,
              outOfStock: item['out_of_stock'] as bool,
              createdAt: DateTime.parse(item['created_at'] as String),
              updatedAt: DateTime.parse(item['updated_at'] as String),
            ),
          )
          .toList();

      return StorageEntity(
        id: data['id'].toString(),
        name: data['name'] as String,
        description: data['description'] as String?,
        spaceId: data['space_id'].toString(),
        spaceName: data['space_name'] as String,
        parentId: data['parent_id']?.toString(),
        imageUrl: data['image_url'] as String?,
        childrenCount: data['children_count'] as int,
        itemsCount: data['items_count'] as int,
        children: children,
        items: items,
        createdAt: DateTime.parse(data['created_at'] as String),
        updatedAt: DateTime.parse(data['updated_at'] as String),
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Failed to get storage details',
    );
  }

  // Browse implementations
  @override
  Future<List<BrowseNode>> browseSpaces() async {
    final response = await dioClient.get('browse/spaces');
    if (response.statusCode == 200) {
      final List<dynamic> spaces =
          response.data['data']['spaces'] as List<dynamic>;
      return spaces
          .map(
            (e) => BrowseNode(
              id: e['id'].toString(),
              name: e['name'] as String,
              type: BrowseNodeType.space,
              hasChildren: (e['has_children'] as bool?) ?? false,
              childrenCount: (e['storages_count'] as num?)?.toInt(),
            ),
          )
          .toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Failed to browse spaces',
    );
  }

  @override
  Future<List<BrowseNode>> browseStorages({
    String? spaceId,
    String? parentId,
  }) async {
    final query = <String, dynamic>{};
    if (spaceId != null) query['space_id'] = spaceId;
    if (parentId != null) query['parent_id'] = parentId;

    final response = await dioClient.get(
      'browse/storages',
      queryParameters: query,
    );
    if (response.statusCode == 200) {
      final List<dynamic> storages =
          response.data['data']['storages'] as List<dynamic>;
      return storages
          .map(
            (e) => BrowseNode(
              id: e['id'].toString(),
              name: e['name'] as String,
              type: BrowseNodeType.storage,
              hasChildren: (e['has_children'] as bool?) ?? false,
              childrenCount: (e['children_count'] as num?)?.toInt(),
              spaceId: e['space_id']?.toString(),
              parentId: e['parent_id']?.toString(),
            ),
          )
          .toList();
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Failed to browse storages',
    );
  }

  // Categories implementation
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dioClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> categories = data['categories'] ?? [];
        return categories
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load categories',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<CategoryModel> createCategory(String name) async {
    try {
      final response = await dioClient.post(
        ApiConstants.categories,
        data: {
          'category': {'name': name},
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        final categoryData = data['category'] ?? data;
        return CategoryModel.fromJson(categoryData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to create category',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ItemEntity> getItemDetails(String itemId) async {
    try {
      final response = await dioClient.get('${ApiConstants.items}/$itemId');
      
      if (response.statusCode == 200) {
        final data = response.data['data']['item'];
        
        // Helper function to parse quantity (handles both string and num)
        double parseQuantity(dynamic value) {
          if (value == null) return 0.0;
          if (value is num) return value.toDouble();
          if (value is String) {
            return double.tryParse(value) ?? 0.0;
          }
          return 0.0;
        }

        // Helper function to parse optional numeric fields
        double? parseOptionalDouble(dynamic value) {
          if (value == null) return null;
          if (value is num) return value.toDouble();
          if (value is String) {
            return double.tryParse(value);
          }
          return null;
        }

        return ItemEntity(
          id: data['id'].toString(),
          name: data['name'] as String,
          quantity: parseQuantity(data['quantity']),
          unit: data['unit'] as String,
          minQuantity: parseOptionalDouble(data['min_quantity']),
          outOfStockThreshold: parseOptionalDouble(data['out_of_stock_threshold']),
          lowStockAlertEnabled: data['low_stock_alert_enabled'] as bool,
          outOfStockAlertEnabled: data['out_of_stock_alert_enabled'] as bool,
          expirationDate: data['expiration_date'] as String?,
          notes: data['notes'] as String?,
          imageUrl: data['image_url'] as String?,
          lowStock: data['low_stock'] as bool,
          outOfStock: data['out_of_stock'] as bool,
          createdAt: DateTime.parse(data['created_at'] as String),
          updatedAt: DateTime.parse(data['updated_at'] as String),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to get item details',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Get item details with location and categories information
  @override
  Future<Map<String, dynamic>> getItemDetailsWithLocation(String itemId) async {
    try {
      final response = await dioClient.get('${ApiConstants.items}/$itemId');
      
      if (response.statusCode == 200) {
        final data = response.data['data']['item'];
        
        // Parse categories
        final categories = (data['categories'] as List<dynamic>?)
                ?.map((cat) => cat['name'] as String)
                .toList() ??
            <String>[];
        
        // Extract location information from location_array
        final locationArray = data['location_array'] as List<dynamic>?;
        String? spaceId;
        String? spaceName;
        String? storageId;
        String? storageName;
        
        if (locationArray != null) {
          // Find space (first item with type 'space')
          for (final location in locationArray) {
            final type = location['type'] as String;
            if (type == 'space') {
              spaceId = location['id'].toString();
              spaceName = location['name'] as String;
              break;
            }
          }
          
          // Find the storage directly containing the item (last storage before item)
          // Reverse iterate to find the last storage before the item
          for (int i = locationArray.length - 1; i >= 0; i--) {
            final location = locationArray[i];
            final type = location['type'] as String;
            if (type == 'storage') {
              storageId = location['id'].toString();
              storageName = location['name'] as String;
              break;
            }
          }
        }
        
        // Fallback to storage_id and storage_name if location_array is not available
        if (storageId == null) {
          storageId = data['storage_id']?.toString();
          storageName = data['storage_name'] as String?;
        }
        
        // Helper function to parse quantity (handles both string and num)
        double parseQuantity(dynamic value) {
          if (value == null) return 0.0;
          if (value is num) return value.toDouble();
          if (value is String) {
            return double.tryParse(value) ?? 0.0;
          }
          return 0.0;
        }

        // Helper function to parse optional numeric fields
        double? parseOptionalDouble(dynamic value) {
          if (value == null) return null;
          if (value is num) return value.toDouble();
          if (value is String) {
            return double.tryParse(value);
          }
          return null;
        }

        return {
          'item': ItemEntity(
            id: data['id'].toString(),
            name: data['name'] as String,
            quantity: parseQuantity(data['quantity']),
            unit: data['unit'] as String,
            minQuantity: parseOptionalDouble(data['min_quantity']),
            outOfStockThreshold: parseOptionalDouble(data['out_of_stock_threshold']),
            lowStockAlertEnabled: data['low_stock_alert_enabled'] as bool,
            outOfStockAlertEnabled: data['out_of_stock_alert_enabled'] as bool,
            expirationDate: data['expiration_date'] as String?,
            notes: data['notes'] as String?,
            imageUrl: data['image_url'] as String?,
            lowStock: data['low_stock'] as bool,
            outOfStock: data['out_of_stock'] as bool,
            createdAt: DateTime.parse(data['created_at'] as String),
            updatedAt: DateTime.parse(data['updated_at'] as String),
          ),
          'location_path': data['location_path'] as String? ?? '',
          'categories': categories,
          'space_id': spaceId,
          'space_name': spaceName,
          'storage_id': storageId,
          'storage_name': storageName,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to get item details',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
