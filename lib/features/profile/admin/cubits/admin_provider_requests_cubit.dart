import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/features/profile/admin/cubits/admin_provider_requests_states.dart';
import 'package:tourist_app/features/profile/admin/models/admin_provider_request.dart';

class AdminProviderRequestsCubit extends Cubit<AdminProviderRequestsState> {
  final Dio _dio;
  List<AdminProviderRequest> _requests = [];

  AdminProviderRequestsCubit(this._dio) : super(AdminProviderRequestsInitial());

  Future<void> fetchRequests() async {
    try {
      emit(AdminProviderRequestsLoading());
      final response = await _dio.get(ApiConstant.adminProviderRequestsEndPoint);
      _requests = AdminProviderRequest.listFromResponse(response.data);
      emit(AdminProviderRequestsLoaded(_requests));
    } catch (e) {
      emit(AdminProviderRequestsError(_getErrorMessage(e)));
    }
  }

  Future<void> fetchRequestDetails(String id) async {
    if (id.isEmpty) return;

    try {
      emit(AdminProviderRequestDetailsLoading(_requests));
      final response = await _dio.get(
        '${ApiConstant.adminProviderRequestsEndPoint}/$id',
      );
      final request = AdminProviderRequest.fromResponse(response.data);
      emit(AdminProviderRequestDetailsLoaded(_requests, request));
    } catch (e) {
      emit(AdminProviderRequestsError(_getErrorMessage(e)));
    }
  }

  Future<void> approveRequest(String id) async {
    if (id.isEmpty) return;

    try {
      emit(AdminProviderRequestDetailsLoading(_requests));
      await _dio.put('${ApiConstant.adminProviderRequestsEndPoint}/$id/approve');
      await fetchRequests();
    } catch (e) {
      emit(AdminProviderRequestsError(_getErrorMessage(e)));
    }
  }

  Future<void> rejectRequest(String id) async {
    if (id.isEmpty) return;

    try {
      emit(AdminProviderRequestDetailsLoading(_requests));
      await _dio.put('${ApiConstant.adminProviderRequestsEndPoint}/$id/reject');
      await fetchRequests();
    } catch (e) {
      emit(AdminProviderRequestsError(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      final error = e.error;
      if (error is AppException) return error.message;
      return e.message ?? 'Something went wrong';
    }
    if (e is AppException) return e.message;
    return e.toString();
  }
}
