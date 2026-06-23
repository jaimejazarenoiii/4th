import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

class AddSpace implements UseCase<void, AddSpaceParams> {
  final InventoryRepository repository;

  AddSpace(this.repository);

  @override
  Future<Either<Failure, void>> call(AddSpaceParams params) async {
    return await repository.addSpace(
      params.name,
      params.description,
      params.image,
    );
  }
}

class AddSpaceParams extends Equatable {
  final String name;
  final String? description;
  final File? image;

  const AddSpaceParams({required this.name, this.description, this.image});

  @override
  List<Object?> get props => [name, description, image];
}
