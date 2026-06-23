import 'package:equatable/equatable.dart';

class DashboardStorageEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int spaceId;
  final String spaceName;
  final String? locationPath;
  final int itemsCount;
  final int substoragesCount;
  final int totalItemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardStorageEntity({
    required this.id,
    required this.name,
    this.description,
    required this.spaceId,
    required this.spaceName,
    this.locationPath,
    required this.itemsCount,
    required this.substoragesCount,
    required this.totalItemsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    spaceId,
    spaceName,
    locationPath,
    itemsCount,
    substoragesCount,
    totalItemsCount,
    createdAt,
    updatedAt,
  ];
}
