import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

// Add Item
class AddItem implements UseCase<void, AddItemParams> {
  final InventoryRepository repository;

  AddItem(this.repository);

  @override
  Future<Either<Failure, void>> call(AddItemParams params) async {
    return await repository.addItem(
      params.spaceId,
      params.storageId,
      params.name,
      params.description,
      params.quantity,
    );
  }
}

class AddItemParams extends Equatable {
  final String spaceId;
  final String storageId;
  final String name;
  final String? description;
  final int? quantity;

  const AddItemParams({
    required this.spaceId,
    required this.storageId,
    required this.name,
    this.description,
    this.quantity,
  });

  @override
  List<Object?> get props => [spaceId, storageId, name, description, quantity];
}

// Update Item
class UpdateItem implements UseCase<void, UpdateItemParams> {
  final InventoryRepository repository;

  UpdateItem(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateItemParams params) async {
    return await repository.updateItem(
      params.spaceId,
      params.storageId,
      params.itemId,
      params.name,
      params.description,
      params.quantity,
    );
  }
}

class UpdateItemParams extends Equatable {
  final String spaceId;
  final String storageId;
  final String itemId;
  final String name;
  final String? description;
  final int? quantity;

  const UpdateItemParams({
    required this.spaceId,
    required this.storageId,
    required this.itemId,
    required this.name,
    this.description,
    this.quantity,
  });

  @override
  List<Object?> get props => [spaceId, storageId, itemId, name, description, quantity];
}

// Delete Item
class DeleteItem implements UseCase<void, DeleteItemParams> {
  final InventoryRepository repository;

  DeleteItem(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteItemParams params) async {
    return await repository.deleteItem(params.spaceId, params.storageId, params.itemId);
  }
}

class DeleteItemParams extends Equatable {
  final String spaceId;
  final String storageId;
  final String itemId;

  const DeleteItemParams({
    required this.spaceId,
    required this.storageId,
    required this.itemId,
  });

  @override
  List<Object> get props => [spaceId, storageId, itemId];
}

