import 'package:tourist_app/api/model/response/auth/UserDto.dart';
import 'package:tourist_app/api/model/response/profile/place_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<UserDto> getProfileMe();
  Future<List<PlaceDto>> getSavedPlaces();
  Future<void> savePlace(String placeId);
  Future<void> unsavePlace(String placeId);
  Future<List<PlaceDto>> getVisitedPlaces();
  Future<void> visitPlace(String placeId);
}
