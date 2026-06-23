import 'package:equatable/equatable.dart';

class DashboardItemEntity extends Equatable {
  final int id;
  final String name;
  final String? notes;
  final int quantity;
  final String? unit;
  final int storageId;
  final String storageName;
  final String spaceName;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardItemEntity({
    required this.id,
    required this.name,
    this.notes,
    required this.quantity,
    this.unit,
    required this.storageId,
    required this.storageName,
    required this.spaceName,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    notes,
    quantity,
    unit,
    storageId,
    storageName,
    spaceName,
    imageUrl,
    createdAt,
    updatedAt,
  ];
}
