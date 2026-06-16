import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class GetTripByIdUseCase {
  final TripsRepoContract _repository;

  GetTripByIdUseCase(this._repository);

  Future<Trip> invoke(String id) {
    return _repository.getTripById(id);
  }
}
