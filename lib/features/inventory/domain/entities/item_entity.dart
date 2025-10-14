import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final int? quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemEntity({
    required this.id,
    required this.name,
    this.description,
    this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, quantity, createdAt, updatedAt];
}

