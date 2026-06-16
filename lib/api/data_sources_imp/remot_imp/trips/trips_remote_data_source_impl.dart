import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/model/request/trips/create_trip_request_dto.dart';
import 'package:tourist_app/api/model/request/trips/create_activity_request_dto.dart';
import 'package:tourist_app/api/model/response/trips/trip_dto.dart';
import 'package:tourist_app/data/data_sources/remot/trips/trips_remote_data_source.dart';

@Injectable(as: TripsRemoteDataSource)
class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final ApiServices _apiServices;

  TripsRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<TripDto>> getTrips() async {
    return await _apiServices.getTrips();
  }

  @override
  Future<TripDto> createTrip(CreateTripRequestDto request) async {
    return await _apiServices.createTrip(request);
  }

  @override
  Future<TripDto> getTripById(String id) async {
    return await _apiServices.getTripById(id);
  }

  @override
  Future<TripDto> updateTrip(String id, CreateTripRequestDto request) async {
    return await _apiServices.updateTrip(id, request);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _apiServices.deleteTrip(id);
  }

  @override
  Future<TripActivityDto> addActivity(String tripId, String dayId, CreateActivityRequestDto request) async {
    return await _apiServices.addActivity(tripId, dayId, request);
  }

  @override
  Future<void> deleteActivity(String tripId, String activityId) async {
    await _apiServices.deleteActivity(tripId, activityId);
  }
}
