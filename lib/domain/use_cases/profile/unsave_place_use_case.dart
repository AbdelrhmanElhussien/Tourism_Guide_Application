import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';

@injectable
class UnsavePlaceUseCase {
  final ProfileRepoContract _repository;

  UnsavePlaceUseCase(this._repository);

  Future<void> invoke(String placeId) {
    return _repository.unsavePlace(placeId);
  }
}
