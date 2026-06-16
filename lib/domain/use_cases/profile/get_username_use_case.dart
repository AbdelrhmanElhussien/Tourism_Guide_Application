import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/profile/profile_repo_contract.dart';

@injectable
class GetUsernameUseCase {
  final ProfileRepoContract _repository;

  GetUsernameUseCase(this._repository);

  Future<String> invoke() {
    return _repository.getUsername();
  }
}
