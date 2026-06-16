import 'package:tourist_app/api/model/request/trips/create_trip_request_dto.dart';
import 'package:tourist_app/api/model/request/trips/create_activity_request_dto.dart';
import 'package:tourist_app/api/model/response/trips/trip_dto.dart';

abstract class TripsRemoteDataSource {
  Future<List<TripDto>> getTrips();
  Future<TripDto> createTrip(CreateTripRequestDto request);
  Future<TripDto> getTripById(String id);
  Future<TripDto> updateTrip(String id, CreateTripRequestDto request);
  Future<void> deleteTrip(String id);
  Future<TripActivityDto> addActivity(String tripId, String dayId, CreateActivityRequestDto request);
  Future<void> deleteActivity(String tripId, String activityId);
}
