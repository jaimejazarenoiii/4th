import 'package:equatable/equatable.dart';
import '../../domain/entities/space_entity.dart';

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<SpaceEntity> spaces;

  const InventoryLoaded({required this.spaces});

  @override
  List<Object> get props => [spaces];
}

class InventoryError extends InventoryState {
  final String message;

  const InventoryError({required this.message});

  @override
  List<Object> get props => [message];
}

