import 'package:tourist_app/domain/entities/trips/trip_entity.dart';

sealed class TripsState {}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsSuccess extends TripsState {
  final List<Trip> trips;
  final Trip? selectedTrip;

  TripsSuccess({
    required this.trips,
    this.selectedTrip,
  });

  TripsSuccess copyWith({
    List<Trip>? trips,
    Trip? selectedTrip,
  }) {
    return TripsSuccess(
      trips: trips ?? this.trips,
      selectedTrip: selectedTrip ?? this.selectedTrip,
    );
  }
}

class TripsError extends TripsState {
  final String errorMsg;
  TripsError({required this.errorMsg});
}
