import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Bloc for handling dashboard functionality
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardData _getDashboardData;

  DashboardBloc({required GetDashboardData getDashboardData})
    : _getDashboardData = getDashboardData,
      super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  /// Handle loading dashboard data
  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await _getDashboardData(NoParams());

    await result.fold(
      (failure) async => emit(DashboardError(failure.message)),
      (dashboardData) async => emit(DashboardLoaded(dashboardData)),
    );
  }

  /// Handle refreshing dashboard data
  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    // For refresh, we can show loading state or keep current data
    // and update in background. For now, let's reload completely.
    add(const LoadDashboardData());
  }
}
