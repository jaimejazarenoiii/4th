import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/space_entity.dart';
import '../repositories/inventory_repository.dart';

class GetSpaces implements UseCase<List<SpaceEntity>, NoParams> {
  final InventoryRepository repository;

  GetSpaces(this.repository);

  @override
  Future<Either<Failure, List<SpaceEntity>>> call(NoParams params) async {
    return await repository.getSpaces();
  }
}

