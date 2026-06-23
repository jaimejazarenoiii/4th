import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/storage_usecases.dart';
import 'create_storage_event.dart';
import 'create_storage_state.dart';

/// Bloc for handling create storage functionality
class CreateStorageBloc extends Bloc<CreateStorageEvent, CreateStorageState> {
  final AddStorage _addStorage;

  CreateStorageBloc({required AddStorage addStorage})
    : _addStorage = addStorage,
      super(const CreateStorageInitial()) {
    on<CreateStorageSubmitted>(_onCreateStorageSubmitted);
    on<CreateStorageReset>(_onCreateStorageReset);
    on<CreateStorageFieldUpdated>(_onCreateStorageFieldUpdated);
  }

  /// Handle storage creation submission
  Future<void> _onCreateStorageSubmitted(
    CreateStorageSubmitted event,
    Emitter<CreateStorageState> emit,
  ) async {
    // Validate input
    final validationResult = _validateInput(event.title, event.description);
    if (validationResult != null) {
      emit(validationResult);
      return;
    }

    emit(const CreateStorageLoading());

    try {
      // Call the use case to add the storage
      final result = await _addStorage(
        AddStorageParams(
          name: event.title.trim(),
          description: event.description.trim().isEmpty
              ? null
              : event.description.trim(),
          spaceId: event.spaceId,
          parentStorageId: event.parentStorageId,
          image: event.image,
        ),
      );

      // Handle the Either result
      result.fold(
        (failure) {
          if (failure is PlanLimitFailure) {
            emit(
              CreateStoragePlanLimitReached(
                message: failure.message,
                resource: failure.resource,
                limit: failure.limit,
              ),
            );
          } else {
            emit(
              CreateStorageError(
                message: failure.message,
              ),
            );
          }
        },
        (_) => emit(const CreateStorageSuccess()),
      );
    } catch (e) {
      emit(
        CreateStorageError(
          message: 'Failed to create storage: ${e.toString()}',
        ),
      );
    }
  }

  /// Handle form reset
  void _onCreateStorageReset(
    CreateStorageReset event,
    Emitter<CreateStorageState> emit,
  ) {
    emit(const CreateStorageInitial());
  }

  /// Handle field updates (for real-time validation if needed)
  void _onCreateStorageFieldUpdated(
    CreateStorageFieldUpdated event,
    Emitter<CreateStorageState> emit,
  ) {
    // For now, just emit initial state
    // This can be extended for real-time validation
    emit(const CreateStorageInitial());
  }

  /// Validate input fields
  CreateStorageValidationError? _validateInput(
    String title,
    String description,
  ) {
    String? titleError;
    String? descriptionError;

    // Title is required
    if (title.trim().isEmpty) {
      titleError = 'Title is required';
    }

    // Description is optional, but if provided, it should not be just whitespace
    if (description.trim().isNotEmpty && description.trim().length < 3) {
      descriptionError = 'Description must be at least 3 characters long';
    }

    if (titleError != null || descriptionError != null) {
      return CreateStorageValidationError(
        titleError: titleError,
        descriptionError: descriptionError,
      );
    }

    return null;
  }
}
