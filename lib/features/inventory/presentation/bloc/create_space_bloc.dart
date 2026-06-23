import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_space.dart';
import 'create_space_event.dart';
import 'create_space_state.dart';

/// Bloc for handling create space functionality
class CreateSpaceBloc extends Bloc<CreateSpaceEvent, CreateSpaceState> {
  final AddSpace _addSpace;

  CreateSpaceBloc({required AddSpace addSpace})
    : _addSpace = addSpace,
      super(const CreateSpaceInitial()) {
    on<CreateSpaceSubmitted>(_onCreateSpaceSubmitted);
    on<CreateSpaceReset>(_onCreateSpaceReset);
    on<CreateSpaceFieldUpdated>(_onCreateSpaceFieldUpdated);
  }

  /// Handle space creation submission
  Future<void> _onCreateSpaceSubmitted(
    CreateSpaceSubmitted event,
    Emitter<CreateSpaceState> emit,
  ) async {
    // Validate input
    final validationResult = _validateInput(event.title, event.description);
    if (validationResult != null) {
      emit(validationResult);
      return;
    }

    emit(const CreateSpaceLoading());

    try {
      // Call the use case to add the space
      final result = await _addSpace(
        AddSpaceParams(
          name: event.title.trim(),
          description: event.description.trim().isEmpty
              ? null
              : event.description.trim(),
          image: event.image,
        ),
      );

      result.fold(
        (failure) {
          if (failure is PlanLimitFailure) {
            emit(
              CreateSpacePlanLimitReached(
                message: failure.message,
                resource: failure.resource,
                limit: failure.limit,
              ),
            );
          } else {
            emit(CreateSpaceError(message: failure.message));
          }
        },
        (_) => emit(const CreateSpaceSuccess()),
      );
    } catch (e) {
      emit(
        CreateSpaceError(message: 'Failed to create space: ${e.toString()}'),
      );
    }
  }

  /// Handle form reset
  void _onCreateSpaceReset(
    CreateSpaceReset event,
    Emitter<CreateSpaceState> emit,
  ) {
    emit(const CreateSpaceInitial());
  }

  /// Handle field updates (for real-time validation if needed)
  void _onCreateSpaceFieldUpdated(
    CreateSpaceFieldUpdated event,
    Emitter<CreateSpaceState> emit,
  ) {
    // For now, just emit initial state
    // This can be extended for real-time validation
    emit(const CreateSpaceInitial());
  }

  /// Validate input fields
  CreateSpaceValidationError? _validateInput(String title, String description) {
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
      return CreateSpaceValidationError(
        titleError: titleError,
        descriptionError: descriptionError,
      );
    }

    return null;
  }
}
