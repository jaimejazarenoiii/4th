import 'package:equatable/equatable.dart';

/// States for the CreateSpaceBloc
abstract class CreateSpaceState extends Equatable {
  const CreateSpaceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CreateSpaceInitial extends CreateSpaceState {
  const CreateSpaceInitial();
}

/// Loading state while creating space
class CreateSpaceLoading extends CreateSpaceState {
  const CreateSpaceLoading();
}

/// Success state when space is created
class CreateSpaceSuccess extends CreateSpaceState {
  const CreateSpaceSuccess();
}

/// Error state when creation fails
class CreateSpaceError extends CreateSpaceState {
  final String message;

  const CreateSpaceError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Plan limit reached state
class CreateSpacePlanLimitReached extends CreateSpaceState {
  final String message;
  final String resource;
  final int? limit;

  const CreateSpacePlanLimitReached({
    required this.message,
    required this.resource,
    this.limit,
  });

  @override
  List<Object?> get props => [message, resource, limit];
}

/// Form validation state
class CreateSpaceValidationError extends CreateSpaceState {
  final String? titleError;
  final String? descriptionError;

  const CreateSpaceValidationError({this.titleError, this.descriptionError});

  @override
  List<Object?> get props => [titleError, descriptionError];
}
