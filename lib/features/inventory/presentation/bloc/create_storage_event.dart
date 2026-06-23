import 'package:equatable/equatable.dart';
import 'dart:io';

/// Events for the CreateStorageBloc
abstract class CreateStorageEvent extends Equatable {
  const CreateStorageEvent();

  @override
  List<Object?> get props => [];
}

/// Event when storage creation is submitted
class CreateStorageSubmitted extends CreateStorageEvent {
  final String title;
  final String description;
  final File? image;
  final String spaceId; // Required for storage creation
  final String? parentStorageId; // Optional for substorage creation

  const CreateStorageSubmitted({
    required this.title,
    required this.description,
    required this.spaceId,
    this.parentStorageId,
    this.image,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    spaceId,
    parentStorageId,
    image,
  ];
}

/// Event to reset the form
class CreateStorageReset extends CreateStorageEvent {
  const CreateStorageReset();
}

/// Event when form fields are updated (for real-time validation)
class CreateStorageFieldUpdated extends CreateStorageEvent {
  final String title;
  final String description;

  const CreateStorageFieldUpdated({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [title, description];
}
