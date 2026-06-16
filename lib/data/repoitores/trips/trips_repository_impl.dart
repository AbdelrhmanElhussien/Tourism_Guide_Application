import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/mapper/trips/trip_mappers.dart';
import 'package:tourist_app/api/model/request/trips/create_trip_request_dto.dart';
import 'package:tourist_app/api/model/request/trips/create_activity_request_dto.dart';
import 'package:tourist_app/data/data_sources/remot/trips/trips_remote_data_source.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@Injectable(as: TripsRepoContract)
class TripsRepositoryImpl implements TripsRepoContract {
  final TripsRemoteDataSource _remoteDataSource;

  TripsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Trip>> getTrips() async {
    final list = await _remoteDataSource.getTrips();
    return list.map((dto) => dto.toTrip()).toList();
  }

  @override
  Future<Trip> createTrip(String title, String startDate, String endDate, String notes) async {
    final dto = await _remoteDataSource.createTrip(CreateTripRequestDto(
      title: title,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    ));
    return dto.toTrip();
  }

  @override
  Future<Trip> getTripById(String id) async {
    final dto = await _remoteDataSource.getTripById(id);
    return dto.toTrip();
  }

  @override
  Future<Trip> updateTrip(String id, String title, String startDate, String endDate, String notes) async {
    final dto = await _remoteDataSource.updateTrip(id, CreateTripRequestDto(
      title: title,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    ));
    return dto.toTrip();
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _remoteDataSource.deleteTrip(id);
  }

  @override
  Future<TripActivity> addActivity(String tripId, String dayId, String title, String time, String notes, String imageUrl) async {
    final dto = await _remoteDataSource.addActivity(tripId, dayId, CreateActivityRequestDto(
      title: title,
      time: time,
      notes: notes,
      imageUrl: imageUrl,
    ));
    return dto.toTripActivity();
  }

  @override
  Future<void> deleteActivity(String tripId, String activityId) async {
    await _remoteDataSource.deleteActivity(tripId, activityId);
  }
}
