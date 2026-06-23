import 'package:equatable/equatable.dart';

class DashboardStorageModel extends Equatable {
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

  const DashboardStorageModel({
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

  factory DashboardStorageModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      throw Exception('Cannot convert $value to int');
    }

    return DashboardStorageModel(
      id: _toInt(json['id']),
      name: json['name'] as String,
      description: json['description'] as String?,
      spaceId: _toInt(json['space_id']),
      spaceName: json['space_name'] as String,
      locationPath: json['location_path'] as String?,
      itemsCount: _toInt(json['items_count'] ?? 0),
      substoragesCount: _toInt(json['substorages_count'] ?? 0),
      totalItemsCount: _toInt(json['total_items_count'] ?? 0),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'space_id': spaceId,
      'space_name': spaceName,
      'location_path': locationPath,
      'items_count': itemsCount,
      'substorages_count': substoragesCount,
      'total_items_count': totalItemsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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
