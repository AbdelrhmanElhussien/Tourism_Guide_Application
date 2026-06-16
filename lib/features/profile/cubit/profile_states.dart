import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String userName;
  final String email;
  final List<TourismDestination> savedPlaces;
  final List<TourismDestination> visitedPlaces;
  final int completedTripsCount;

  ProfileSuccess({
    required this.userName,
    required this.email,
    required this.savedPlaces,
    required this.visitedPlaces,
    required this.completedTripsCount,
  });
}

class ProfileError extends ProfileState {
  final String errorMsg;
  ProfileError({required this.errorMsg});
}
