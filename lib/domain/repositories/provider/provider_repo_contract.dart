import 'package:tourist_app/domain/entities/provider/provider_booking.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';

import 'package:tourist_app/api/model/response/provider/provider_request_response_dto.dart';

abstract class ProviderRepoContract {
  Future<ProviderDashboard> getProviderDashboard();
  Future<List<ProviderService>> getProviderServices();
  Future<ProviderService> createProviderService(
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability, {
    String? placeId,
  });
  Future<ProviderService> getProviderServiceById(String id);
  Future<ProviderService> updateProviderService(
    String id,
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability, {
    String? placeId,
  });
  Future<void> deleteProviderService(String id);
  Future<List<ProviderBooking>> getProviderBookings();
  Future<ProviderBooking> updateBookingStatus(String id, String status);
  Future<void> submitProviderRequest(
    String businessName,
    String businessType,
    String businessDescription,
    String contactNumber,
    String email,
    String taxNumber,
    String registrationNumber,
    String documentUrl,
  );
  Future<ProviderRequestResponseDto> getMyProviderRequest();
  Future<ProviderEarnings> getProviderEarnings();
  Future<ProviderBooking> confirmBooking(String id);
  Future<ProviderBooking> declineBooking(String id);
  Future<ProviderBooking> completeBooking(String id);
  Future<void> contactBooking(String id, String message);
}
