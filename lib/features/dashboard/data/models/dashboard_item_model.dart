import 'package:equatable/equatable.dart';

class DashboardItemModel extends Equatable {
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

  const DashboardItemModel({
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

  factory DashboardItemModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.parse(value);
      if (value is double) return value.toInt();
      throw Exception('Cannot convert $value to int');
    }

    // Helper function to safely convert quantity (might be double)
    int _toQuantity(dynamic value) {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return double.parse(value).toInt();
      return 0;
    }

    return DashboardItemModel(
      id: _toInt(json['id']),
      name: json['name'] as String,
      notes: json['notes'] as String?,
      quantity: _toQuantity(json['quantity'] ?? 0),
      unit: json['unit'] as String?,
      storageId: _toInt(json['storage_id']),
      storageName: json['storage_name'] as String,
      spaceName: json['space_name'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'quantity': quantity,
      'unit': unit,
      'storage_id': storageId,
      'storage_name': storageName,
      'space_name': spaceName,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

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
