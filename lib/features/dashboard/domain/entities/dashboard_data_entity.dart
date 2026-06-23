import 'package:equatable/equatable.dart';
import 'dashboard_space_entity.dart';
import 'dashboard_storage_entity.dart';
import 'dashboard_item_entity.dart';

class DashboardDataEntity extends Equatable {
  final List<DashboardSpaceEntity> spaces;
  final List<DashboardStorageEntity> storages;
  final List<DashboardItemEntity> items;

  const DashboardDataEntity({
    required this.spaces,
    required this.storages,
    required this.items,
  });

  @override
  List<Object> get props => [spaces, storages, items];
}
