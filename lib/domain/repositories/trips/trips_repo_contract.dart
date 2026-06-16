import 'package:tourist_app/domain/entities/trips/trip_entity.dart';

abstract class TripsRepoContract {
  Future<List<Trip>> getTrips();
  Future<Trip> createTrip(String title, String startDate, String endDate, String notes);
  Future<Trip> getTripById(String id);
  Future<Trip> updateTrip(String id, String title, String startDate, String endDate, String notes);
  Future<void> deleteTrip(String id);
  Future<TripActivity> addActivity(String tripId, String dayId, String title, String time, String notes, String imageUrl);
  Future<void> deleteActivity(String tripId, String activityId);
}
