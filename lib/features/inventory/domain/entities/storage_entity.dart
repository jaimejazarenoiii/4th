import 'package:equatable/equatable.dart';
import 'item_entity.dart';

class StorageEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String spaceId;
  final String spaceName;
  final String? parentId;
  final String? imageUrl;
  final int childrenCount;
  final int itemsCount;
  final List<StorageEntity> children;
  final List<ItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StorageEntity({
    required this.id,
    required this.name,
    this.description,
    required this.spaceId,
    required this.spaceName,
    this.parentId,
    this.imageUrl,
    required this.childrenCount,
    required this.itemsCount,
    required this.children,
    required this.items,
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
    parentId,
    imageUrl,
    childrenCount,
    itemsCount,
    children,
    items,
    createdAt,
    updatedAt,
  ];
}
