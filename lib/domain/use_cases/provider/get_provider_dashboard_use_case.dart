import 'package:injectable/injectable.dart';
import 'package:tourist_app/domain/entities/provider/provider_dashboard.dart';
import 'package:tourist_app/domain/repositories/provider/provider_repo_contract.dart';

@injectable
class GetProviderDashboardUseCase {
  final ProviderRepoContract _repository;

  GetProviderDashboardUseCase(this._repository);

  Future<ProviderDashboard> invoke() {
    return _repository.getProviderDashboard();
  }
}
