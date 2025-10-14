import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

// Add Storage
class AddStorage implements UseCase<void, AddStorageParams> {
  final InventoryRepository repository;

  AddStorage(this.repository);

  @override
  Future<Either<Failure, void>> call(AddStorageParams params) async {
    return await repository.addStorage(params.spaceId, params.name, params.description);
  }
}

class AddStorageParams extends Equatable {
  final String spaceId;
  final String name;
  final String? description;

  const AddStorageParams({
    required this.spaceId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [spaceId, name, description];
}

// Update Storage
class UpdateStorage implements UseCase<void, UpdateStorageParams> {
  final InventoryRepository repository;

  UpdateStorage(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateStorageParams params) async {
    return await repository.updateStorage(
      params.spaceId,
      params.storageId,
      params.name,
      params.description,
    );
  }
}

class UpdateStorageParams extends Equatable {
  final String spaceId;
  final String storageId;
  final String name;
  final String? description;

  const UpdateStorageParams({
    required this.spaceId,
    required this.storageId,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [spaceId, storageId, name, description];
}

// Delete Storage
class DeleteStorage implements UseCase<void, DeleteStorageParams> {
  final InventoryRepository repository;

  DeleteStorage(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteStorageParams params) async {
    return await repository.deleteStorage(params.spaceId, params.storageId);
  }
}

class DeleteStorageParams extends Equatable {
  final String spaceId;
  final String storageId;

  const DeleteStorageParams({
    required this.spaceId,
    required this.storageId,
  });

  @override
  List<Object> get props => [spaceId, storageId];
}

