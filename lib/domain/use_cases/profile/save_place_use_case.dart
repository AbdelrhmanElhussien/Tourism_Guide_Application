import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';

@injectable
class SavePlaceUseCase {
  final ProfileRepoContract _repository;

  SavePlaceUseCase(this._repository);

  Future<void> invoke(String placeId) {
    return _repository.savePlace(placeId);
  }
}
