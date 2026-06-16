import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/mapper/provider/provider_mappers.dart';
import 'package:tourist_app/api/model/request/provider/create_service_request_dto.dart';
import 'package:tourist_app/data/data_sources/remot/provider/provider_remote_data_source.dart';
import 'package:tourist_app/domain/entities/provider/provider_booking.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';
import 'package:tourist_app/domain/repositories/provider/provider_repo_contract.dart';

@Injectable(as: ProviderRepoContract)
class ProviderRepositoryImpl implements ProviderRepoContract {
  final ProviderRemoteDataSource _remoteDataSource;

  ProviderRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProviderDashboard> getProviderDashboard() async {
    final dto = await _remoteDataSource.getProviderDashboard();
    return dto.toProviderDashboard();
  }

  @override
  Future<List<ProviderService>> getProviderServices() async {
    final list = await _remoteDataSource.getProviderServices();
    return list.map((dto) => dto.toProviderService()).toList();
  }

  @override
  Future<ProviderService> createProviderService(
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability,
  ) async {
    final dto = await _remoteDataSource.createProviderService(CreateServiceRequestDto(
      title: title,
      description: description,
      price: price,
      duration: duration,
      location: location,
      category: category,
      availability: availability,
    ));
    return dto.toProviderService();
  }

  @override
  Future<ProviderService> getProviderServiceById(String id) async {
    final dto = await _remoteDataSource.getProviderServiceById(id);
    return dto.toProviderService();
  }

  @override
  Future<ProviderService> updateProviderService(
    String id,
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability,
  ) async {
    final dto = await _remoteDataSource.updateProviderService(id, CreateServiceRequestDto(
      title: title,
      description: description,
      price: price,
      duration: duration,
      location: location,
      category: category,
      availability: availability,
    ));
    return dto.toProviderService();
  }

  @override
  Future<void> deleteProviderService(String id) async {
    await _remoteDataSource.deleteProviderService(id);
  }

  @override
  Future<List<ProviderBooking>> getProviderBookings() async {
    final list = await _remoteDataSource.getProviderBookings();
    return list.map((dto) => dto.toProviderBooking()).toList();
  }

  @override
  Future<ProviderBooking> updateBookingStatus(String id, String status) async {
    final dto = await _remoteDataSource.updateBookingStatus(id, status);
    return dto.toProviderBooking();
  }

  @override
  Future<void> submitProviderRequest() async {
    await _remoteDataSource.submitProviderRequest();
  }

  @override
  Future<dynamic> getMyProviderRequest() async {
    return await _remoteDataSource.getMyProviderRequest();
  }

  @override
  Future<ProviderEarnings> getProviderEarnings() async {
    final dto = await _remoteDataSource.getProviderEarnings();
    return dto.toProviderEarnings();
  }

  @override
  Future<ProviderBooking> confirmBooking(String id) async {
    final dto = await _remoteDataSource.confirmBooking(id);
    return dto.toProviderBooking();
  }

  @override
  Future<ProviderBooking> declineBooking(String id) async {
    final dto = await _remoteDataSource.declineBooking(id);
    return dto.toProviderBooking();
  }

  @override
  Future<ProviderBooking> completeBooking(String id) async {
    final dto = await _remoteDataSource.completeBooking(id);
    return dto.toProviderBooking();
  }

  @override
  Future<void> contactBooking(String id) async {
    await _remoteDataSource.contactBooking(id);
  }
}
