import '../../domain/entities/storage_entity.dart';
import 'item_model.dart';

class StorageModel extends StorageEntity {
  const StorageModel({
    required super.id,
    required super.name,
    super.description,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      items: (json['items'] as List<dynamic>?)
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
      'items': items.map((item) => (item as ItemModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  StorageModel copyWith({
    String? name,
    String? description,
    List<ItemModel>? items,
    DateTime? updatedAt,
  }) {
    return StorageModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

