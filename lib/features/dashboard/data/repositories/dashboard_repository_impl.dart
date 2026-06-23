import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_data_entity.dart';
import '../../domain/entities/dashboard_space_entity.dart';
import '../../domain/entities/dashboard_storage_entity.dart';
import '../../domain/entities/dashboard_item_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/dashboard_data_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardDataEntity>> getDashboardData() async {
    try {
      final dashboardData = await remoteDataSource.getDashboardData();
      return Right(_mapToEntity(dashboardData));
    } catch (e) {
      return Left(
        ServerFailure('Failed to load dashboard data: ${e.toString()}'),
      );
    }
  }

  DashboardDataEntity _mapToEntity(DashboardDataModel model) {
    return DashboardDataEntity(
      spaces: model.spaces
          .map(
            (space) => DashboardSpaceEntity(
              id: space.id,
              name: space.name,
              description: space.description,
              imageUrl: space.imageUrl,
              storagesCount: space.storagesCount,
              substoragesCount: space.substoragesCount,
              itemsCount: space.itemsCount,
              createdAt: space.createdAt,
              updatedAt: space.updatedAt,
            ),
          )
          .toList(),
      storages: model.storages
          .map(
            (storage) => DashboardStorageEntity(
              id: storage.id,
              name: storage.name,
              description: storage.description,
              spaceId: storage.spaceId,
              spaceName: storage.spaceName,
              locationPath: storage.locationPath,
              itemsCount: storage.itemsCount,
              substoragesCount: storage.substoragesCount,
              totalItemsCount: storage.totalItemsCount,
              createdAt: storage.createdAt,
              updatedAt: storage.updatedAt,
            ),
          )
          .toList(),
      items: model.items
          .map(
            (item) => DashboardItemEntity(
              id: item.id,
              name: item.name,
              notes: item.notes,
              quantity: item.quantity,
              unit: item.unit,
              storageId: item.storageId,
              storageName: item.storageName,
              spaceName: item.spaceName,
              imageUrl: item.imageUrl,
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            ),
          )
          .toList(),
    );
  }
}
