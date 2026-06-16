import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';
import 'package:tourist_app/features/home/widgets/tourism_destination.dart';

@injectable
class GetSavedPlacesUseCase {
  final ProfileRepoContract _repository;

  GetSavedPlacesUseCase(this._repository);

  Future<List<TourismDestination>> invoke() {
    return _repository.getSavedPlaces();
  }
}
