import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/use_cases/trips/get_trip_by_id_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/get_trips_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/create_trip_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/update_trip_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/delete_trip_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/add_activity_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/delete_activity_use_case.dart';
import 'package:tourist_app/features/profile/cubit/trips_states.dart';

@injectable
class TripsCubit extends Cubit<TripsState> {
  final GetTripsUseCase _getTripsUseCase;
  final GetTripByIdUseCase _getTripByIdUseCase;
  final CreateTripUseCase _createTripUseCase;
  final UpdateTripUseCase _updateTripUseCase;
  final DeleteTripUseCase _deleteTripUseCase;
  final AddActivityUseCase _addActivityUseCase;
  final DeleteActivityUseCase _deleteActivityUseCase;

  TripsCubit(
    this._getTripsUseCase,
    this._getTripByIdUseCase,
    this._createTripUseCase,
    this._updateTripUseCase,
    this._deleteTripUseCase,
    this._addActivityUseCase,
    this._deleteActivityUseCase,
  ) : super(TripsInitial());

  Future<void> fetchTrips() async {
    try {
      emit(TripsLoading());
      final trips = await _getTripsUseCase.invoke();
      if (trips.isNotEmpty) {
        try {
          final detailedFirstTrip = await _getTripByIdUseCase.invoke(trips.first.id);
          emit(TripsSuccess(trips: trips, selectedTrip: detailedFirstTrip));
        } catch (_) {
          // Fallback if detail fetch fails for some reason
          emit(TripsSuccess(trips: trips, selectedTrip: null));
        }
      } else {
        emit(TripsSuccess(trips: const [], selectedTrip: null));
      }
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }

  Future<void> selectTrip(String id) async {
    final currentState = state;
    if (currentState is TripsSuccess) {
      try {
        final detailedTrip = await _getTripByIdUseCase.invoke(id);
        emit(currentState.copyWith(selectedTrip: detailedTrip));
      } catch (e) {
        emit(TripsError(errorMsg: e.toString()));
      }
    }
  }

  Future<void> createTrip(String title, String startDate, String endDate, String notes) async {
    try {
      emit(TripsLoading());
      await _createTripUseCase.invoke(title, startDate, endDate, notes);
      await fetchTrips();
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }

  Future<void> updateTrip(String id, String title, String startDate, String endDate, String notes) async {
    try {
      emit(TripsLoading());
      await _updateTripUseCase.invoke(id, title, startDate, endDate, notes);
      await fetchTrips();
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }

  Future<void> deleteTrip(String id) async {
    try {
      emit(TripsLoading());
      await _deleteTripUseCase.invoke(id);
      await fetchTrips();
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }

  Future<void> addActivity(
    String tripId,
    String dayId,
    String title,
    String time,
    String notes,
    String imageUrl,
  ) async {
    try {
      await _addActivityUseCase.invoke(tripId, dayId, title, time, notes, imageUrl);
      await selectTrip(tripId);
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }

  Future<void> deleteActivity(String tripId, String activityId) async {
    try {
      await _deleteActivityUseCase.invoke(tripId, activityId);
      await selectTrip(tripId);
    } catch (e) {
      emit(TripsError(errorMsg: e.toString()));
    }
  }
}
