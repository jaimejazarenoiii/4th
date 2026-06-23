import 'dart:io';
import 'package:equatable/equatable.dart';

/// Events for the CreateSpaceBloc
abstract class CreateSpaceEvent extends Equatable {
  const CreateSpaceEvent();

  @override
  List<Object?> get props => [];
}

/// Event to create a new space
class CreateSpaceSubmitted extends CreateSpaceEvent {
  final String title;
  final String description;
  final File? image;

  const CreateSpaceSubmitted({
    required this.title,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [title, description, image];
}

/// Event to reset the create space form
class CreateSpaceReset extends CreateSpaceEvent {
  const CreateSpaceReset();
}

/// Event to update form fields
class CreateSpaceFieldUpdated extends CreateSpaceEvent {
  final String? title;
  final String? description;
  final File? image;

  const CreateSpaceFieldUpdated({this.title, this.description, this.image});

  @override
  List<Object?> get props => [title, description, image];
}
