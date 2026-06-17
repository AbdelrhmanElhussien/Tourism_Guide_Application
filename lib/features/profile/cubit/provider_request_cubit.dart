import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/use_cases/provider/provider_use_cases.dart';
import 'provider_request_states.dart';

@injectable
class ProviderRequestCubit extends Cubit<ProviderRequestState> {
  final GetMyProviderRequestUseCase _getMyProviderRequestUseCase;
  final SubmitProviderRequestUseCase _submitProviderRequestUseCase;

  ProviderRequestCubit(
    this._getMyProviderRequestUseCase,
    this._submitProviderRequestUseCase,
  ) : super(ProviderRequestInitial());

  String _getErrorMessage(dynamic e) {
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
    return msg;
  }

  Future<void> fetchMyRequest() async {
    try {
      emit(ProviderRequestLoading());
      final response = await _getMyProviderRequestUseCase.invoke();
      emit(ProviderRequestLoaded(response));
    } catch (e) {
      // If the backend returns a 404 or success=false because no request exists, handle it gracefully
      if (e is DioException && e.response?.statusCode == 404) {
        emit(ProviderRequestLoaded(null));
      } else {
        emit(ProviderRequestError(_getErrorMessage(e)));
      }
    }
  }

  Future<void> submitRequest({
    required String businessName,
    required String businessType,
    required String businessDescription,
    required String contactNumber,
    required String email,
    required String taxNumber,
    required String registrationNumber,
    required String documentUrl,
  }) async {
    try {
      emit(ProviderRequestSubmitting());
      await _submitProviderRequestUseCase.invoke(
        businessName: businessName,
        businessType: businessType,
        businessDescription: businessDescription,
        contactNumber: contactNumber,
        email: email,
        taxNumber: taxNumber,
        registrationNumber: registrationNumber,
        documentUrl: documentUrl,
      );
      emit(ProviderRequestSubmitSuccess());
      await fetchMyRequest();
    } catch (e) {
      emit(ProviderRequestError(_getErrorMessage(e)));
    }
  }
}
