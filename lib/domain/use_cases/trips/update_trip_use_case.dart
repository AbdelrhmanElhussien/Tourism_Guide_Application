import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class UpdateTripUseCase {
  final TripsRepoContract _repository;

  UpdateTripUseCase(this._repository);

  Future<Trip> invoke(String id, String title, String startDate, String endDate, String notes) {
    return _repository.updateTrip(id, title, startDate, endDate, notes);
  }
}
