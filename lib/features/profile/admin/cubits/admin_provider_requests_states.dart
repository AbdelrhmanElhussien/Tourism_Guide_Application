import 'package:tourist_app/features/profile/admin/models/admin_provider_request.dart';

abstract class AdminProviderRequestsState {}

class AdminProviderRequestsInitial extends AdminProviderRequestsState {}

class AdminProviderRequestsLoading extends AdminProviderRequestsState {}

class AdminProviderRequestsLoaded extends AdminProviderRequestsState {
  final List<AdminProviderRequest> requests;

  AdminProviderRequestsLoaded(this.requests);
}

class AdminProviderRequestDetailsLoading extends AdminProviderRequestsState {
  final List<AdminProviderRequest> requests;

  AdminProviderRequestDetailsLoading(this.requests);
}

class AdminProviderRequestDetailsLoaded extends AdminProviderRequestsState {
  final List<AdminProviderRequest> requests;
  final AdminProviderRequest selectedRequest;

  AdminProviderRequestDetailsLoaded(this.requests, this.selectedRequest);
}

class AdminProviderRequestsError extends AdminProviderRequestsState {
  final String errorMsg;

  AdminProviderRequestsError(this.errorMsg);
}
