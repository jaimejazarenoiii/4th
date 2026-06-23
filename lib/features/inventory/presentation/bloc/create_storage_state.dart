import 'package:equatable/equatable.dart';

/// States for the CreateStorageBloc
abstract class CreateStorageState extends Equatable {
  const CreateStorageState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CreateStorageInitial extends CreateStorageState {
  const CreateStorageInitial();
}

/// Loading state
class CreateStorageLoading extends CreateStorageState {
  const CreateStorageLoading();
}

/// Success state
class CreateStorageSuccess extends CreateStorageState {
  const CreateStorageSuccess();
}

/// Error state
class CreateStorageError extends CreateStorageState {
  final String message;

  const CreateStorageError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Plan limit reached state
class CreateStoragePlanLimitReached extends CreateStorageState {
  final String message;
  final String resource;
  final int? limit;

  const CreateStoragePlanLimitReached({
    required this.message,
    required this.resource,
    this.limit,
  });

  @override
  List<Object?> get props => [message, resource, limit];
}

/// Validation error state
class CreateStorageValidationError extends CreateStorageState {
  final String? titleError;
  final String? descriptionError;

  const CreateStorageValidationError({this.titleError, this.descriptionError});

  @override
  List<Object?> get props => [titleError, descriptionError];
}
