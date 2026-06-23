import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_data_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardDataEntity>> getDashboardData();
}
