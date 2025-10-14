import '../../domain/entities/space_entity.dart';
import 'storage_model.dart';

class SpaceModel extends SpaceEntity {
  const SpaceModel({
    required super.id,
    required super.name,
    super.description,
    required super.storages,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SpaceModel.fromJson(Map<String, dynamic> json) {
    return SpaceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      storages: (json['storages'] as List<dynamic>?)
              ?.map((storage) => StorageModel.fromJson(storage))
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
      'storages': storages.map((storage) => (storage as StorageModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SpaceModel copyWith({
    String? name,
    String? description,
    List<StorageModel>? storages,
    DateTime? updatedAt,
  }) {
    return SpaceModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      storages: storages ?? this.storages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

