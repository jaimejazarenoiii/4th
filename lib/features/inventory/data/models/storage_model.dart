import '../../domain/entities/storage_entity.dart';
import 'item_model.dart';

class StorageModel extends StorageEntity {
  const StorageModel({
    required super.id,
    required super.name,
    super.description,
    required super.spaceId,
    required super.spaceName,
    super.parentId,
    super.imageUrl,
    required super.childrenCount,
    required super.itemsCount,
    required super.children,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      spaceId: json['spaceId'] ?? '',
      spaceName: json['spaceName'] ?? '',
      parentId: json['parentId'],
      imageUrl: json['imageUrl'],
      childrenCount: json['childrenCount'] ?? 0,
      itemsCount: json['itemsCount'] ?? 0,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((child) => StorageModel.fromJson(child))
              .toList() ??
          [],
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => ItemModel.fromJson(item))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'spaceId': spaceId,
      'spaceName': spaceName,
      'parentId': parentId,
      'imageUrl': imageUrl,
      'childrenCount': childrenCount,
      'itemsCount': itemsCount,
      'children': children
          .map((child) => (child as StorageModel).toJson())
          .toList(),
      'items': items.map((item) => (item as ItemModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  StorageModel copyWith({
    String? name,
    String? description,
    String? spaceId,
    String? spaceName,
    String? parentId,
    String? imageUrl,
    int? childrenCount,
    int? itemsCount,
    List<StorageModel>? children,
    List<ItemModel>? items,
    DateTime? updatedAt,
  }) {
    return StorageModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      spaceId: spaceId ?? this.spaceId,
      spaceName: spaceName ?? this.spaceName,
      parentId: parentId ?? this.parentId,
      imageUrl: imageUrl ?? this.imageUrl,
      childrenCount: childrenCount ?? this.childrenCount,
      itemsCount: itemsCount ?? this.itemsCount,
      children: children ?? this.children,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
