import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';
import 'package:tourist_app/core/utils/cache_helper.dart';
import 'package:tourist_app/domain/entities/response/auth/User.dart';
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

      final user = results[0] as User;
      final userName = user.name ?? 'User';
      final email = user.email ?? 'user@example.com';
      final role = user.role;
      final savedPlaces = results[1] as List;
      final List<TourismDestination> mergedSavedPlaces = List.from(savedPlaces.map((item) => item as TourismDestination));

      // Load local favorites
      try {
        final localJson = CacheHelper.getData(key: 'local_favorites_$email');
        if (localJson != null && localJson is String) {
          final List<dynamic> localList = jsonDecode(localJson);
          for (final raw in localList) {
            final id = raw['id']?.toString();
            if (id != null && !mergedSavedPlaces.any((item) => item.id == id)) {
              mergedSavedPlaces.add(TourismDestination(
                id: id,
                title: raw['title']?.toString() ?? '',
                location: raw['location']?.toString() ?? '',
                rating: (raw['rating'] as num?)?.toDouble() ?? 0.0,
                reviews: (raw['reviews'] as num?)?.toInt() ?? 0,
                category: raw['category']?.toString() ?? 'Historical',
                networkImage: raw['networkImage']?.toString(),
                assetImage: raw['assetImage']?.toString(),
              ));
            }
          }
        }
      } catch (_) {}

      final visitedPlaces = results[2] as List;
      final trips = results[3] as List<Trip>;

      await CacheHelper.saveData(key: 'userName', value: userName);
      await CacheHelper.saveData(key: 'email', value: email);
      if (role != null) {
        await CacheHelper.saveData(key: 'role', value: role);
      }

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
        savedPlaces: mergedSavedPlaces,
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
