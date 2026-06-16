import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class DeleteActivityUseCase {
  final TripsRepoContract _repository;

  DeleteActivityUseCase(this._repository);

  Future<void> invoke(String tripId, String activityId) {
    return _repository.deleteActivity(tripId, activityId);
  }
}
