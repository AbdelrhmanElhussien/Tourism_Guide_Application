import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class GetTripsUseCase {
  final TripsRepoContract _repository;

  GetTripsUseCase(this._repository);

  Future<List<Trip>> invoke() {
    return _repository.getTrips();
  }
}
