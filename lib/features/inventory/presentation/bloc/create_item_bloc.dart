import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/item_usecases.dart';
import '../../domain/usecases/category_usecases.dart';
import '../../domain/entities/category_entity.dart';
import 'create_item_event.dart';
import 'create_item_state.dart';

/// Bloc for handling create item functionality
class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  final AddItem _addItem;
  final UpdateItem _updateItem;
  final GetCategories _getCategories;
  final CreateCategory _createCategory;

  CreateItemBloc({
    required AddItem addItem,
    required UpdateItem updateItem,
    required GetCategories getCategories,
    required CreateCategory createCategory,
  })  : _addItem = addItem,
        _updateItem = updateItem,
        _getCategories = getCategories,
        _createCategory = createCategory,
        super(const CreateItemInitial()) {
    on<CreateItemSubmitted>(_onCreateItemSubmitted);
    on<CreateItemReset>(_onCreateItemReset);
    on<CreateItemFieldUpdated>(_onCreateItemFieldUpdated);
    on<FetchCategories>(_onFetchCategories);
  }

  /// Handle item creation submission
  Future<void> _onCreateItemSubmitted(
    CreateItemSubmitted event,
    Emitter<CreateItemState> emit,
  ) async {
    // Validate input
    final validationResult = _validateInput(event.title, event.description);
    if (validationResult != null) {
      emit(validationResult);
      return;
    }

    emit(const CreateItemLoading());

    try {
      // First, handle categories - create new ones and get IDs
      List<int> categoryIds = [];
      if (event.categories.isNotEmpty) {
        // Fetch existing categories to check which ones are new
        final categoriesResult = await _getCategories(const NoParams());
        final existingCategories = categoriesResult.fold(
          (_) => <CategoryEntity>[],
          (categories) => categories,
        );

        // Create new categories and collect all category IDs
        for (final categoryName in event.categories) {
          final categoryLower = categoryName.toLowerCase();
          final existingCategoryIndex = existingCategories.indexWhere(
            (c) => c.name.toLowerCase() == categoryLower,
          );

          if (existingCategoryIndex >= 0) {
            // Category exists, use its ID
            categoryIds.add(existingCategories[existingCategoryIndex].id);
          } else {
            // Create new category
            final createResult = await _createCategory(
              CreateCategoryParams(name: categoryName),
            );
            createResult.fold(
              (failure) => throw Exception(
                'Failed to create category: ${failure.message}',
              ),
              (category) => categoryIds.add(category.id),
            );
          }
        }
      }

      // Call the appropriate use case (add or update)
      if (event.itemId != null) {
        // Update existing item
        final result = await _updateItem(
          UpdateItemParams(
            spaceId: event.spaceId,
            storageId: event.storageId,
            itemId: event.itemId!,
            name: event.title.trim(),
            description: event.description?.trim().isEmpty ?? true
                ? null
                : event.description?.trim(),
            quantity: event.quantity?.toInt(),
          ),
        );

        result.fold(
          (failure) {
            if (failure is PlanLimitFailure) {
              emit(
                CreateItemPlanLimitReached(
                  message: failure.message,
                  resource: failure.resource,
                  limit: failure.limit,
                ),
              );
            } else {
              emit(
                CreateItemError(
                  message: 'Failed to update item: ${failure.message}',
                ),
              );
            }
          },
          (_) => emit(const CreateItemSuccess()),
        );
      } else {
        // Create new item
        final result = await _addItem(
          AddItemParams(
            spaceId: event.spaceId,
            storageId: event.storageId,
            name: event.title.trim(),
            description: event.description?.trim().isEmpty ?? true
                ? null
                : event.description?.trim(),
            quantity: event.quantity?.toInt(),
            expiryDate: event.expiryDate,
            unit: event.unit,
            categoryIds: categoryIds.isNotEmpty ? categoryIds : null,
            image: event.image,
          ),
        );

        result.fold(
          (failure) {
            if (failure is PlanLimitFailure) {
              emit(
                CreateItemPlanLimitReached(
                  message: failure.message,
                  resource: failure.resource,
                  limit: failure.limit,
                ),
              );
            } else {
              emit(
                CreateItemError(
                  message: failure.message,
                ),
              );
            }
          },
          (_) => emit(const CreateItemSuccess()),
        );
      }
    } catch (e) {
      emit(
        CreateItemError(
          message: 'Failed to create item: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle fetch categories
  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CreateItemState> emit,
  ) async {
    try {
      final result = await _getCategories(const NoParams());
      result.fold(
        (failure) => emit(
          CreateItemError(
            message: 'Failed to load categories: ${failure.message}',
          ),
        ),
        (categories) => emit(CreateItemCategoriesLoaded(categories)),
      );
    } catch (e) {
      emit(
        CreateItemError(
          message: 'Failed to load categories: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle form reset
  void _onCreateItemReset(
    CreateItemReset event,
    Emitter<CreateItemState> emit,
  ) {
    emit(const CreateItemInitial());
  }

  /// Handle field updates (for real-time validation if needed)
  void _onCreateItemFieldUpdated(
    CreateItemFieldUpdated event,
    Emitter<CreateItemState> emit,
  ) {
    // For now, just emit initial state
    // This can be extended for real-time validation
    emit(const CreateItemInitial());
  }

  /// Validate input fields
  CreateItemValidationError? _validateInput(
    String title,
    String? description,
  ) {
    String? titleError;
    String? descriptionError;

    // Title is required
    if (title.trim().isEmpty) {
      titleError = 'Title is required';
    }

    // Description is optional, but if provided, it should not be just whitespace
    if (description != null &&
        description.trim().isNotEmpty &&
        description.trim().length < 3) {
      descriptionError = 'Description must be at least 3 characters long';
    }

    if (titleError != null || descriptionError != null) {
      return CreateItemValidationError(
        titleError: titleError,
        descriptionError: descriptionError,
      );
    }

    return null;
  }
}


