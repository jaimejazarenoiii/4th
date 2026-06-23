import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_data_entity.dart';

/// States for the DashboardBloc
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {}

/// Loading state
class DashboardLoading extends DashboardState {}

/// Success state with dashboard data
class DashboardLoaded extends DashboardState {
  final DashboardDataEntity dashboardData;

  const DashboardLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData];
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
