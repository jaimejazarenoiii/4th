import 'package:equatable/equatable.dart';
import 'storage_entity.dart';

class SpaceEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<StorageEntity> storages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SpaceEntity({
    required this.id,
    required this.name,
    this.description,
    required this.storages,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, storages, createdAt, updatedAt];
}

