import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:tourist_app/api/mapper/profile/profile_mappers.dart';
import 'package:tourist_app/data/data_sources/remot/profile/profile_remote_data_source.dart';
import 'package:tourist_app/domain/entities/response/auth/User.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepositoryImpl implements ProfileRepoContract {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> getProfileMe() async {
    final dto = await _remoteDataSource.getProfileMe();
    return User(
      name: dto.name ?? dto.userName ?? dto.username ?? dto.fullName ?? dto.fullname,
      email: dto.email,
      role: dto.role,
    );
  }

  @override
  Future<List<TourismDestination>> getSavedPlaces() async {
    final list = await _remoteDataSource.getSavedPlaces();
    return list.map((dto) => dto.toTourismDestination()).toList();
  }

  @override
  Future<void> savePlace(String placeId) async {
    await _remoteDataSource.savePlace(placeId);
  }

  @override
  Future<void> unsavePlace(String placeId) async {
    await _remoteDataSource.unsavePlace(placeId);
  }

  @override
  Future<List<TourismDestination>> getVisitedPlaces() async {
    final list = await _remoteDataSource.getVisitedPlaces();
    return list.map((dto) => dto.toTourismDestination()).toList();
  }

  @override
  Future<void> visitPlace(String placeId) async {
    await _remoteDataSource.visitPlace(placeId);
  }
}
