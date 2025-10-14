import 'package:equatable/equatable.dart';
import 'item_entity.dart';

class StorageEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<ItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StorageEntity({
    required this.id,
    required this.name,
    this.description,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, items, createdAt, updatedAt];
}

