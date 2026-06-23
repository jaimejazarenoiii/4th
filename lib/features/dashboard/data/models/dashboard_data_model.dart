import 'package:equatable/equatable.dart';
import 'dashboard_space_model.dart';
import 'dashboard_storage_model.dart';
import 'dashboard_item_model.dart';

class DashboardDataModel extends Equatable {
  final List<DashboardSpaceModel> spaces;
  final List<DashboardStorageModel> storages;
  final List<DashboardItemModel> items;

  const DashboardDataModel({
    required this.spaces,
    required this.storages,
    required this.items,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      spaces:
          (json['spaces'] as List<dynamic>?)
              ?.map((space) => DashboardSpaceModel.fromJson(space))
              .toList() ??
          [],
      storages:
          (json['storages'] as List<dynamic>?)
              ?.map((storage) => DashboardStorageModel.fromJson(storage))
              .toList() ??
          [],
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => DashboardItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spaces': spaces.map((space) => space.toJson()).toList(),
      'storages': storages.map((storage) => storage.toJson()).toList(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [spaces, storages, items];
}
