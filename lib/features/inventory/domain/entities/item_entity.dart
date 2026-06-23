import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final double? minQuantity;
  final double? outOfStockThreshold;
  final bool lowStockAlertEnabled;
  final bool outOfStockAlertEnabled;
  final String? expirationDate;
  final String? notes;
  final String? imageUrl;
  final bool lowStock;
  final bool outOfStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.minQuantity,
    this.outOfStockThreshold,
    required this.lowStockAlertEnabled,
    required this.outOfStockAlertEnabled,
    this.expirationDate,
    this.notes,
    this.imageUrl,
    required this.lowStock,
    required this.outOfStock,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    quantity,
    unit,
    minQuantity,
    outOfStockThreshold,
    lowStockAlertEnabled,
    outOfStockAlertEnabled,
    expirationDate,
    notes,
    imageUrl,
    lowStock,
    outOfStock,
    createdAt,
    updatedAt,
  ];
}
