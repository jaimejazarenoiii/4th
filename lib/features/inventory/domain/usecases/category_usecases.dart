import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';
import '../entities/category_entity.dart';

// Get Categories
class GetCategories implements UseCase<List<CategoryEntity>, NoParams> {
  final InventoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}

// Create Category
class CreateCategory implements UseCase<CategoryEntity, CreateCategoryParams> {
  final InventoryRepository repository;

  CreateCategory(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(
    CreateCategoryParams params,
  ) async {
    return await repository.createCategory(params.name);
  }
}

class CreateCategoryParams extends Equatable {
  final String name;

  const CreateCategoryParams({required this.name});

  @override
  List<Object?> get props => [name];
}



