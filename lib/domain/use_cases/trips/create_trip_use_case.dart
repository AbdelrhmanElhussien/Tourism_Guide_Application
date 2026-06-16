import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class CreateTripUseCase {
  final TripsRepoContract _repository;

  CreateTripUseCase(this._repository);

  Future<Trip> invoke(String title, String startDate, String endDate, String notes) {
    return _repository.createTrip(title, startDate, endDate, notes);
  }
}
