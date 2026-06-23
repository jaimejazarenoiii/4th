import '../../domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.unit,
    super.minQuantity,
    super.outOfStockThreshold,
    required super.lowStockAlertEnabled,
    required super.outOfStockAlertEnabled,
    super.expirationDate,
    super.notes,
    super.imageUrl,
    required super.lowStock,
    required super.outOfStock,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'pcs',
      minQuantity: json['minQuantity']?.toDouble(),
      outOfStockThreshold: json['outOfStockThreshold']?.toDouble(),
      lowStockAlertEnabled: json['lowStockAlertEnabled'] ?? false,
      outOfStockAlertEnabled: json['outOfStockAlertEnabled'] ?? false,
      expirationDate: json['expirationDate'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      lowStock: json['lowStock'] ?? false,
      outOfStock: json['outOfStock'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'minQuantity': minQuantity,
      'outOfStockThreshold': outOfStockThreshold,
      'lowStockAlertEnabled': lowStockAlertEnabled,
      'outOfStockAlertEnabled': outOfStockAlertEnabled,
      'expirationDate': expirationDate,
      'notes': notes,
      'imageUrl': imageUrl,
      'lowStock': lowStock,
      'outOfStock': outOfStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ItemModel copyWith({
    String? name,
    double? quantity,
    String? unit,
    double? minQuantity,
    double? outOfStockThreshold,
    bool? lowStockAlertEnabled,
    bool? outOfStockAlertEnabled,
    String? expirationDate,
    String? notes,
    String? imageUrl,
    bool? lowStock,
    bool? outOfStock,
    DateTime? updatedAt,
  }) {
    return ItemModel(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      minQuantity: minQuantity ?? this.minQuantity,
      outOfStockThreshold: outOfStockThreshold ?? this.outOfStockThreshold,
      lowStockAlertEnabled: lowStockAlertEnabled ?? this.lowStockAlertEnabled,
      outOfStockAlertEnabled:
          outOfStockAlertEnabled ?? this.outOfStockAlertEnabled,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      lowStock: lowStock ?? this.lowStock,
      outOfStock: outOfStock ?? this.outOfStock,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
