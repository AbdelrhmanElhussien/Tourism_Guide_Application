import 'package:tourist_app/domain/entities/response/auth/User.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

abstract class ProfileRepoContract {
  Future<User> getProfileMe();
  Future<List<TourismDestination>> getSavedPlaces();
  Future<void> savePlace(String placeId);
  Future<void> unsavePlace(String placeId);
  Future<List<TourismDestination>> getVisitedPlaces();
  Future<void> visitPlace(String placeId);
}
