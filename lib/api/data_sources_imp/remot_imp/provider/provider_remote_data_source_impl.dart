import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/model/request/provider/create_service_request_dto.dart';
import 'package:tourist_app/api/model/request/provider/update_service_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_booking_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_dashboard_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_earnings_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_service_dto.dart';
import 'package:tourist_app/data/data_sources/remot/provider/provider_remote_data_source.dart';

import 'package:tourist_app/api/model/request/provider/provider_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_request_response_dto.dart';

@Injectable(as: ProviderRemoteDataSource)
class ProviderRemoteDataSourceImpl implements ProviderRemoteDataSource {
  final ApiServices _apiServices;

  ProviderRemoteDataSourceImpl(this._apiServices);

  @override
  Future<ProviderDashboardDto> getProviderDashboard() async {
    return await _apiServices.getProviderDashboard();
  }

  @override
  Future<List<ProviderServiceDto>> getProviderServices() async {
    return await _apiServices.getProviderServices();
  }

  @override
  Future<ProviderServiceDto> createProviderService(CreateServiceRequestDto request) async {
    return await _apiServices.createProviderService(request);
  }

  @override
  Future<ProviderServiceDto> getProviderServiceById(String id) async {
    return await _apiServices.getProviderServiceById(id);
  }

  @override
  Future<ProviderServiceDto> updateProviderService(String id, UpdateServiceRequestDto request) async {
    return await _apiServices.updateProviderService(id, request);
  }

  @override
  Future<void> deleteProviderService(String id) async {
    await _apiServices.deleteProviderService(id);
  }

  @override
  Future<List<ProviderBookingDto>> getProviderBookings() async {
    return await _apiServices.getProviderBookings();
  }

  @override
  Future<ProviderBookingDto> updateBookingStatus(String id, String status) async {
    return await _apiServices.updateBookingStatus(id, {'status': status});
  }

  @override
  Future<void> submitProviderRequest(ProviderRequestDto request) async {
    await _apiServices.submitProviderRequest(request);
  }

  @override
  Future<ProviderRequestResponseDto> getMyProviderRequest() async {
    return await _apiServices.getMyProviderRequest();
  }

  @override
  Future<ProviderEarningsDto> getProviderEarnings() async {
    return await _apiServices.getProviderEarnings();
  }

  @override
  Future<ProviderBookingDto> confirmBooking(String id) async {
    return await _apiServices.confirmBooking(id);
  }

  @override
  Future<ProviderBookingDto> declineBooking(String id) async {
    return await _apiServices.declineBooking(id);
  }

  @override
  Future<ProviderBookingDto> completeBooking(String id) async {
    return await _apiServices.completeBooking(id);
  }

  @override
  Future<void> contactBooking(String id, String message) async {
    await _apiServices.contactBooking(id, {
      "bookingId": id,
      "message": message,
    });
  }
}
