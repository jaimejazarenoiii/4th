import 'package:equatable/equatable.dart';

class DashboardSpaceModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int storagesCount;
  final int substoragesCount;
  final int itemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DashboardSpaceModel({
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

  factory DashboardSpaceModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw Exception('Cannot convert $value to int');
    }

    return DashboardSpaceModel(
      id: _toInt(json['id']),
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      storagesCount: _toInt(json['storages_count'] ?? 0),
      substoragesCount: _toInt(json['substorages_count'] ?? 0),
      itemsCount: _toInt(json['items_count'] ?? 0),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'storages_count': storagesCount,
      'substorages_count': substoragesCount,
      'items_count': itemsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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
