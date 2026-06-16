import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/trips/trip_entity.dart';
import 'package:tourist_app/domain/repositories/trips/trips_repo_contract.dart';

@injectable
class AddActivityUseCase {
  final TripsRepoContract _repository;

  AddActivityUseCase(this._repository);

  Future<TripActivity> invoke(
    String tripId,
    String dayId,
    String title,
    String time,
    String notes,
    String imageUrl,
  ) {
    return _repository.addActivity(tripId, dayId, title, time, notes, imageUrl);
  }
}
