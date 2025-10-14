import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/space_model.dart';

/// Abstract interface for remote data source
/// This will be used when you want to fetch data from the API instead of local storage
abstract class InventoryRemoteDataSource {
  Future<List<SpaceModel>> getSpaces();
  Future<SpaceModel> createSpace(String name, String? description);
  Future<SpaceModel> updateSpace(String id, String name, String? description);
  Future<void> deleteSpace(String id);
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
  Future<SpaceModel> createSpace(String name, String? description) async {
    try {
      final response = await dioClient.post(
        ApiConstants.spaces,
        data: {
          'name': name,
          'description': description,
        },
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
  Future<SpaceModel> updateSpace(String id, String name, String? description) async {
    try {
      final response = await dioClient.put(
        '${ApiConstants.spaces}/$id',
        data: {
          'name': name,
          'description': description,
        },
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
  Future<void> createStorage(String spaceId, String name, String? description) async {
    try {
      await dioClient.post(
        '${ApiConstants.spaces}/$spaceId/${ApiConstants.storages}',
        data: {
          'name': name,
          'description': description,
        },
      );
    } on DioException {
      rethrow;
    }
  }

  // Example: Add methods for items
  Future<void> createItem(
    String spaceId,
    String storageId,
    String name,
    String? description,
    int? quantity,
  ) async {
    try {
      await dioClient.post(
        '${ApiConstants.spaces}/$spaceId/${ApiConstants.storages}/$storageId/${ApiConstants.items}',
        data: {
          'name': name,
          'description': description,
          'quantity': quantity,
        },
      );
    } on DioException {
      rethrow;
    }
  }
}

