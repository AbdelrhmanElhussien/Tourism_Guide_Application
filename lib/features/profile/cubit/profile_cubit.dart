import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/use_cases/profile/get_saved_places_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/get_username_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/get_visited_places_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/save_place_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/unsave_place_use_case.dart';
import 'package:tourist_app/domain/use_cases/profile/visit_place_use_case.dart';
import 'package:tourist_app/domain/use_cases/trips/get_trips_use_case.dart';
import 'package:tourist_app/features/profile/cubit/profile_states.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetUsernameUseCase _getUsernameUseCase;
  final GetSavedPlacesUseCase _getSavedPlacesUseCase;
  final GetVisitedPlacesUseCase _getVisitedPlacesUseCase;
  final SavePlaceUseCase _savePlaceUseCase;
  final UnsavePlaceUseCase _unsavePlaceUseCase;
  final VisitPlaceUseCase _visitPlaceUseCase;
  final GetTripsUseCase _getTripsUseCase;

  ProfileCubit(
    this._getUsernameUseCase,
    this._getSavedPlacesUseCase,
    this._getVisitedPlacesUseCase,
    this._savePlaceUseCase,
    this._unsavePlaceUseCase,
    this._visitPlaceUseCase,
    this._getTripsUseCase,
  ) : super(ProfileInitial());

  Future<void> fetchProfileData() async {
    try {
      emit(ProfileLoading());

      final usernameFuture = _getUsernameUseCase.invoke();
      final savedPlacesFuture = _getSavedPlacesUseCase.invoke();
      final visitedPlacesFuture = _getVisitedPlacesUseCase.invoke();
      final tripsFuture = _getTripsUseCase.invoke();

      // Fetch all in parallel
      final results = await Future.wait([
        usernameFuture,
        savedPlacesFuture,
        visitedPlacesFuture,
        tripsFuture,
      ]);

      final userName = results[0] as String;
      final savedPlaces = results[1] as List;
      final visitedPlaces = results[2] as List;
      final trips = results[3] as List<Trip>;

      await CacheHelper.saveData(key: 'userName', value: userName);

      final email = CacheHelper.getData(key: 'email') as String? ?? 'user@example.com';

      // Calculate completed trips count
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      int completedCount = 0;
      for (final trip in trips) {
        final end = DateTime.tryParse(trip.endDate);
        if (end != null && end.isBefore(today)) {
          completedCount++;
        }
      }

      // Safe mapping
      emit(ProfileSuccess(
        userName: userName,
        email: email,
        savedPlaces: List.from(savedPlaces),
        visitedPlaces: List.from(visitedPlaces),
        completedTripsCount: completedCount,
      ));
    } catch (e) {
      emit(ProfileError(errorMsg: e.toString()));
    }
  }

  Future<void> toggleSavePlace(String placeId, bool isCurrentlySaved) async {
    try {
      if (isCurrentlySaved) {
        await _unsavePlaceUseCase.invoke(placeId);
      } else {
        await _savePlaceUseCase.invoke(placeId);
      }
      await fetchProfileData();
    } catch (e) {
      emit(ProfileError(errorMsg: e.toString()));
    }
  }

  Future<void> markAsVisited(String placeId) async {
    try {
      await _visitPlaceUseCase.invoke(placeId);
      await fetchProfileData();
    } catch (e) {
      emit(ProfileError(errorMsg: e.toString()));
    }
  }
}
