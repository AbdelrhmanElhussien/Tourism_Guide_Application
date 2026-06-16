import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';

@injectable
class VisitPlaceUseCase {
  final ProfileRepoContract _repository;

  VisitPlaceUseCase(this._repository);

  Future<void> invoke(String placeId) {
    return _repository.visitPlace(placeId);
  }
}
