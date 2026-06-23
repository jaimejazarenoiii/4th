import 'package:equatable/equatable.dart';

/// Events for the DashboardBloc
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data
class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

/// Event to refresh dashboard data
class RefreshDashboardData extends DashboardEvent {
  const RefreshDashboardData();
}
