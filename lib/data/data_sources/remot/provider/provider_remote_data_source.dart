import 'package:tourist_app/api/model/request/provider/create_service_request_dto.dart';
import 'package:tourist_app/api/model/request/provider/update_service_request_dto.dart';
import 'package:tourist_app/api/model/request/provider/provider_request_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_booking_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_dashboard_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_earnings_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_service_dto.dart';
import 'package:tourist_app/api/model/response/provider/provider_request_response_dto.dart';

abstract class ProviderRemoteDataSource {
  Future<ProviderDashboardDto> getProviderDashboard();
  Future<List<ProviderServiceDto>> getProviderServices();
  Future<ProviderServiceDto> updateProviderService(
    String id,
    String category,
    UpdateServiceRequestDto request,
  );
  Future<void> deleteProviderService(String id, String category);
  Future<void> createCategorizedService(
    String category,
    Map<String, dynamic> data,
  );
  Future<List<ProviderBookingDto>> getProviderBookings();
  Future<ProviderBookingDto> updateBookingStatus(String id, String status);
  Future<void> submitProviderRequest(ProviderRequestDto request);
  Future<ProviderRequestResponseDto> getMyProviderRequest();
  Future<ProviderEarningsDto> getProviderEarnings();
  Future<ProviderBookingDto> confirmBooking(String id);
  Future<ProviderBookingDto> declineBooking(String id);
  Future<ProviderBookingDto> completeBooking(String id);
  Future<void> contactBooking(String id, String message);
}
