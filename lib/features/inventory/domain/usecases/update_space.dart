import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

class UpdateSpace implements UseCase<void, UpdateSpaceParams> {
  final InventoryRepository repository;

  UpdateSpace(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSpaceParams params) async {
    return await repository.updateSpace(params.id, params.name, params.description);
  }
}

class UpdateSpaceParams extends Equatable {
  final String id;
  final String name;
  final String? description;

  const UpdateSpaceParams({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

