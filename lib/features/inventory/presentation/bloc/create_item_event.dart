import 'package:equatable/equatable.dart';
import 'dart:io';

/// Events for the CreateItemBloc
abstract class CreateItemEvent extends Equatable {
  const CreateItemEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch categories
class FetchCategories extends CreateItemEvent {
  const FetchCategories();
}

/// Event when item creation is submitted
class CreateItemSubmitted extends CreateItemEvent {
  final String title;
  final String? description;
  final File? image;
  final String spaceId;
  final String storageId;
  final String? expiryDate;
  final double? quantity;
  final String? unit;
  final List<String> categories;
  final String? itemId; // Optional: if provided, this is an update

  const CreateItemSubmitted({
    required this.title,
    this.description,
    required this.spaceId,
    required this.storageId,
    this.expiryDate,
    this.quantity,
    this.unit,
    this.image,
    this.categories = const [],
    this.itemId,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    spaceId,
    storageId,
    expiryDate,
    quantity,
    unit,
    image,
    categories,
    itemId,
  ];
}

/// Event to reset the form
class CreateItemReset extends CreateItemEvent {
  const CreateItemReset();
}

/// Event when form fields are updated (for real-time validation)
class CreateItemFieldUpdated extends CreateItemEvent {
  final String title;
  final String? description;

  const CreateItemFieldUpdated({
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

