import 'package:tourist_app/domain/entities/provider/provider_service.dart';

sealed class ProviderServicesState {}

class ProviderServicesInitial extends ProviderServicesState {}

class ProviderServicesLoading extends ProviderServicesState {}

class ProviderServicesSuccess extends ProviderServicesState {
  final List<ProviderService> services;
  ProviderServicesSuccess({required this.services});
}

class ProviderServiceActionSuccess extends ProviderServicesState {
  final String message;
  ProviderServiceActionSuccess({required this.message});
}

class ProviderServicesError extends ProviderServicesState {
  final String errorMsg;
  ProviderServicesError({required this.errorMsg});
}
