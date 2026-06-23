import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_data_model.dart';

/// Abstract interface for dashboard remote data source
abstract class DashboardRemoteDataSource {
  Future<DashboardDataModel> getDashboardData();
}

/// Implementation of the dashboard remote data source using Dio
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<DashboardDataModel> getDashboardData() async {
    try {
      final response = await dioClient.get(ApiConstants.dashboard);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return DashboardDataModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load dashboard data',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
