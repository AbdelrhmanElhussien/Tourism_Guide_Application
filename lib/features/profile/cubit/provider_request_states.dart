import 'package:tourist_app/api/model/response/provider/provider_request_response_dto.dart';

abstract class ProviderRequestState {}

class ProviderRequestInitial extends ProviderRequestState {}

class ProviderRequestLoading extends ProviderRequestState {}

class ProviderRequestLoaded extends ProviderRequestState {
  final ProviderRequestResponseDto? requestResponse;
  ProviderRequestLoaded(this.requestResponse);
}

class ProviderRequestSubmitting extends ProviderRequestState {}

class ProviderRequestSubmitSuccess extends ProviderRequestState {}

class ProviderRequestError extends ProviderRequestState {
  final String errorMsg;
  ProviderRequestError(this.errorMsg);
}
