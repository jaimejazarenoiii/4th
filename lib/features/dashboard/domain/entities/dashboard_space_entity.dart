import 'package:equatable/equatable.dart';

class DashboardSpaceEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int storagesCount;
  final int substoragesCount;
  final int itemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardSpaceEntity({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.storagesCount,
    required this.substoragesCount,
    required this.itemsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    storagesCount,
    substoragesCount,
    itemsCount,
    createdAt,
    updatedAt,
  ];
}
