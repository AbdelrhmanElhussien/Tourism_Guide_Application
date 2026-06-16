import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/model/response/profile/place_dto.dart';
import 'package:tourist_app/data/data_sources/remot/profile/profile_remote_data_source.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiServices _apiServices;

  ProfileRemoteDataSourceImpl(this._apiServices);

  @override
  Future<String> getUsername() async {
    return await _apiServices.getUsername();
  }

  @override
  Future<List<PlaceDto>> getSavedPlaces() async {
    return await _apiServices.getSavedPlaces();
  }

  @override
  Future<void> savePlace(String placeId) async {
    await _apiServices.savePlace(placeId);
  }

  @override
  Future<void> unsavePlace(String placeId) async {
    await _apiServices.unsavePlace(placeId);
  }

  @override
  Future<List<PlaceDto>> getVisitedPlaces() async {
    return await _apiServices.getVisitedPlaces();
  }

  @override
  Future<void> visitPlace(String placeId) async {
    await _apiServices.visitPlace(placeId);
  }
}
