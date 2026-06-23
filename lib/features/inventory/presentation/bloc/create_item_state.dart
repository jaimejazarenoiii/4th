import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

/// States for the CreateItemBloc
abstract class CreateItemState extends Equatable {
  const CreateItemState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CreateItemInitial extends CreateItemState {
  const CreateItemInitial();
}

/// Loading state
class CreateItemLoading extends CreateItemState {
  const CreateItemLoading();
}

/// Success state
class CreateItemSuccess extends CreateItemState {
  const CreateItemSuccess();
}

/// Error state
class CreateItemError extends CreateItemState {
  final String message;

  const CreateItemError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Plan limit reached state
class CreateItemPlanLimitReached extends CreateItemState {
  final String message;
  final String resource;
  final int? limit;

  const CreateItemPlanLimitReached({
    required this.message,
    required this.resource,
    this.limit,
  });

  @override
  List<Object?> get props => [message, resource, limit];
}

/// Validation error state
class CreateItemValidationError extends CreateItemState {
  final String? titleError;
  final String? descriptionError;

  const CreateItemValidationError({this.titleError, this.descriptionError});

  @override
  List<Object?> get props => [titleError, descriptionError];
}

/// State with categories loaded
class CreateItemCategoriesLoaded extends CreateItemState {
  final List<CategoryEntity> categories;

  const CreateItemCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

