import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';

sealed class ProviderDashboardState {}

class ProviderDashboardInitial extends ProviderDashboardState {}

class ProviderDashboardLoading extends ProviderDashboardState {}

class ProviderDashboardSuccess extends ProviderDashboardState {
  final ProviderDashboard dashboard;
  final ProviderEarnings earnings;

  ProviderDashboardSuccess({
    required this.dashboard,
    required this.earnings,
  });
}

class ProviderDashboardError extends ProviderDashboardState {
  final String errorMsg;
  ProviderDashboardError({required this.errorMsg});
}
