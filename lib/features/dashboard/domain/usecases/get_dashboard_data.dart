import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_data_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData implements UseCase<DashboardDataEntity, NoParams> {
  final DashboardRepository repository;

  GetDashboardData(this.repository);

  @override
  Future<Either<Failure, DashboardDataEntity>> call(NoParams params) async {
    return await repository.getDashboardData();
  }
}
