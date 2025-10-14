import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

class DeleteSpace implements UseCase<void, DeleteSpaceParams> {
  final InventoryRepository repository;

  DeleteSpace(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteSpaceParams params) async {
    return await repository.deleteSpace(params.id);
  }
}

class DeleteSpaceParams extends Equatable {
  final String id;

  const DeleteSpaceParams({required this.id});

  @override
  List<Object> get props => [id];
}

