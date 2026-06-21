import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:tourist_app/core/exceptions/app_exception.dart';
import 'package:tourist_app/domain/use_cases/provider/provider_use_cases.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/domain/repositories/provider/provider_repo_contract.dart';
import 'provider_services_states.dart';

@injectable
class ProviderServicesCubit extends Cubit<ProviderServicesState> {
  final GetProviderServicesUseCase _getServicesUseCase;
  final UpdateServiceUseCase _updateServiceUseCase;
  final DeleteServiceUseCase _deleteServiceUseCase;

  ProviderServicesCubit(
    this._getServicesUseCase,
    this._updateServiceUseCase,
    this._deleteServiceUseCase,
  ) : super(ProviderServicesInitial());

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

  Future<void> fetchServices() async {
    try {
      emit(ProviderServicesLoading());
      final services = await _getServicesUseCase.invoke();
      emit(ProviderServicesSuccess(services: services));
    } catch (e) {
      emit(ProviderServicesError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> updateService({
    required String id,
    required String title,
    required String description,
    required double price,
    required String duration,
    required String location,
    required String category,
    required List<String> availability,
    String? placeId,
  }) async {
    try {
      emit(ProviderServicesLoading());
      await _updateServiceUseCase.invoke(
        id,
        title,
        description,
        price,
        duration,
        location,
        category,
        availability,
        placeId: placeId,
      );
      emit(ProviderServiceActionSuccess(message: "Service updated successfully!"));
      await fetchServices();
    } catch (e) {
      emit(ProviderServicesError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> deleteService(String id, String category) async {
    try {
      emit(ProviderServicesLoading());
      await _deleteServiceUseCase.invoke(id, category);
      emit(ProviderServiceActionSuccess(message: "Service deleted successfully!"));
      await fetchServices();
    } catch (e) {
      emit(ProviderServicesError(errorMsg: _getErrorMessage(e)));
    }
  }

  Future<void> createCategorizedService(String category, Map<String, dynamic> data) async {
    try {
      emit(ProviderServicesLoading());
      await getIt<ProviderRepoContract>().createCategorizedService(category, data);
      emit(ProviderServiceActionSuccess(message: "Service created successfully!"));
      await fetchServices();
    } catch (e) {
      emit(ProviderServicesError(errorMsg: _getErrorMessage(e)));
    }
  }
}
