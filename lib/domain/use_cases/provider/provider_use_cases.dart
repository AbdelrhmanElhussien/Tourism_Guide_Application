import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/provider/provider_booking.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/domain/entities/provider/provider_service.dart';
import 'package:tourist_app/domain/repositories/provider/provider_repo_contract.dart';

@injectable
class GetProviderServicesUseCase {
  final ProviderRepoContract _repository;
  GetProviderServicesUseCase(this._repository);

  Future<List<ProviderService>> invoke() {
    return _repository.getProviderServices();
  }
}

@injectable
class CreateServiceUseCase {
  final ProviderRepoContract _repository;
  CreateServiceUseCase(this._repository);

  Future<ProviderService> invoke(
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability,
  ) {
    return _repository.createProviderService(
      title,
      description,
      price,
      duration,
      location,
      category,
      availability,
    );
  }
}

@injectable
class GetProviderServiceByIdUseCase {
  final ProviderRepoContract _repository;
  GetProviderServiceByIdUseCase(this._repository);

  Future<ProviderService> invoke(String id) {
    return _repository.getProviderServiceById(id);
  }
}

@injectable
class UpdateServiceUseCase {
  final ProviderRepoContract _repository;
  UpdateServiceUseCase(this._repository);

  Future<ProviderService> invoke(
    String id,
    String title,
    String description,
    double price,
    String duration,
    String location,
    String category,
    List<String> availability,
  ) {
    return _repository.updateProviderService(
      id,
      title,
      description,
      price,
      duration,
      location,
      category,
      availability,
    );
  }
}

@injectable
class DeleteServiceUseCase {
  final ProviderRepoContract _repository;
  DeleteServiceUseCase(this._repository);

  Future<void> invoke(String id) {
    return _repository.deleteProviderService(id);
  }
}

@injectable
class GetProviderBookingsUseCase {
  final ProviderRepoContract _repository;
  GetProviderBookingsUseCase(this._repository);

  Future<List<ProviderBooking>> invoke() {
    return _repository.getProviderBookings();
  }
}

@injectable
class UpdateBookingStatusUseCase {
  final ProviderRepoContract _repository;
  UpdateBookingStatusUseCase(this._repository);

  Future<ProviderBooking> invoke(String id, String status) {
    return _repository.updateBookingStatus(id, status);
  }
}

@injectable
class ConfirmBookingUseCase {
  final ProviderRepoContract _repository;
  ConfirmBookingUseCase(this._repository);

  Future<ProviderBooking> invoke(String id) {
    return _repository.confirmBooking(id);
  }
}

@injectable
class DeclineBookingUseCase {
  final ProviderRepoContract _repository;
  DeclineBookingUseCase(this._repository);

  Future<ProviderBooking> invoke(String id) {
    return _repository.declineBooking(id);
  }
}

@injectable
class CompleteBookingUseCase {
  final ProviderRepoContract _repository;
  CompleteBookingUseCase(this._repository);

  Future<ProviderBooking> invoke(String id) {
    return _repository.completeBooking(id);
  }
}

@injectable
class ContactBookingUseCase {
  final ProviderRepoContract _repository;
  ContactBookingUseCase(this._repository);

  Future<void> invoke(String id) {
    return _repository.contactBooking(id);
  }
}

@injectable
class GetProviderEarningsUseCase {
  final ProviderRepoContract _repository;
  GetProviderEarningsUseCase(this._repository);

  Future<ProviderEarnings> invoke() {
    return _repository.getProviderEarnings();
  }
}

@injectable
class SubmitProviderRequestUseCase {
  final ProviderRepoContract _repository;
  SubmitProviderRequestUseCase(this._repository);

  Future<void> invoke() {
    return _repository.submitProviderRequest();
  }
}

@injectable
class GetMyProviderRequestUseCase {
  final ProviderRepoContract _repository;
  GetMyProviderRequestUseCase(this._repository);

  Future<dynamic> invoke() {
    return _repository.getMyProviderRequest();
  }
}
