import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class DeleteTripUseCase {
  final TripsRepoContract _repository;

  DeleteTripUseCase(this._repository);

  Future<void> invoke(String id) {
    return _repository.deleteTrip(id);
  }
}
