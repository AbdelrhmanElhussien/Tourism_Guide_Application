import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/domain/use_cases/provider/get_provider_dashboard_use_case.dart';
import 'package:tourist_app/domain/use_cases/provider/provider_use_cases.dart';
import 'provider_dashboard_states.dart';

@injectable
class ProviderDashboardCubit extends Cubit<ProviderDashboardState> {
  final GetProviderDashboardUseCase _getDashboardUseCase;
  final GetProviderEarningsUseCase _getEarningsUseCase;

  ProviderDashboardCubit(
    this._getDashboardUseCase,
    this._getEarningsUseCase,
  ) : super(ProviderDashboardInitial());

  Future<void> fetchDashboardData() async {
    try {
      emit(ProviderDashboardLoading());
      
      final dashboardFuture = _getDashboardUseCase.invoke();
      final earningsFuture = _getEarningsUseCase.invoke();

      final results = await Future.wait([
        dashboardFuture,
        earningsFuture,
      ]);

      emit(ProviderDashboardSuccess(
        dashboard: results[0] as ProviderDashboard,
        earnings: results[1] as ProviderEarnings,
      ));
    } catch (e) {
      String msg = e.toString();
      if (e is DioException) {
        if (e.error is AppException) {
          msg = (e.error as AppException).message;
        } else {
          msg = e.message ?? msg;
        }
      } else if (e is AppException) {
        msg = e.message;
      }
      emit(ProviderDashboardError(errorMsg: msg));
    }
  }
}
