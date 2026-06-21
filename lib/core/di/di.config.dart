// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;

import '../../api/api_services.dart' as _i394;
import '../../api/data_sources_imp/remot_imp/auth/auth_remote_dataSrc_impl.dart'
    as _i677;
import '../../api/data_sources_imp/remot_imp/profile/profile_remote_data_source_impl.dart'
    as _i498;
import '../../api/data_sources_imp/remot_imp/provider/provider_remote_data_source_impl.dart'
    as _i765;
import '../../api/data_sources_imp/remot_imp/trips/trips_remote_data_source_impl.dart'
    as _i357;
import '../../api/dio/get_It_module.dart' as _i878;
import '../../data/data_sources/remot/auth/authRemoteDataSource.dart' as _i73;
import '../../data/data_sources/remot/profile/profile_remote_data_source.dart'
    as _i249;
import '../../data/data_sources/remot/provider/provider_remote_data_source.dart'
    as _i867;
import '../../data/data_sources/remot/trips/trips_remote_data_source.dart'
    as _i453;
import '../../data/repoitores/auth/authRepositoryImpl.dart' as _i554;
import '../../data/repoitores/profile/profile_repository_impl.dart' as _i1071;
import '../../data/repoitores/provider/provider_repository_impl.dart' as _i946;
import '../../data/repoitores/trips/trips_repository_impl.dart' as _i609;
import '../../domain/repositories/auth/authRepoContract.dart' as _i482;
import '../../domain/repositories/profile/profile_repo_contract.dart' as _i974;
import '../../domain/repositories/provider/provider_repo_contract.dart'
    as _i869;
import '../../domain/repositories/trips/trips_repo_contract.dart' as _i832;
import '../../domain/use_cases/loginInUseCase.dart' as _i175;
import '../../domain/use_cases/profile/get_saved_places_use_case.dart'
    as _i1020;
import '../../domain/use_cases/profile/get_username_use_case.dart' as _i311;
import '../../domain/use_cases/profile/get_visited_places_use_case.dart'
    as _i539;
import '../../domain/use_cases/profile/save_place_use_case.dart' as _i415;
import '../../domain/use_cases/profile/unsave_place_use_case.dart' as _i149;
import '../../domain/use_cases/profile/visit_place_use_case.dart' as _i316;
import '../../domain/use_cases/provider/get_provider_dashboard_use_case.dart'
    as _i769;
import '../../domain/use_cases/provider/provider_use_cases.dart' as _i517;
import '../../domain/use_cases/signUpUseCase.dart' as _i870;
import '../../domain/use_cases/trips/add_activity_use_case.dart' as _i347;
import '../../domain/use_cases/trips/create_trip_use_case.dart' as _i402;
import '../../domain/use_cases/trips/delete_activity_use_case.dart' as _i423;
import '../../domain/use_cases/trips/delete_trip_use_case.dart' as _i614;
import '../../domain/use_cases/trips/get_trip_by_id_use_case.dart' as _i91;
import '../../domain/use_cases/trips/get_trips_use_case.dart' as _i605;
import '../../domain/use_cases/trips/update_trip_use_case.dart' as _i211;
import '../../features/auth/login/cubit/login_view_model.dart' as _i959;
import '../../features/auth/signup/cubit/register_view_model.dart' as _i369;
import '../../features/profile/cubit/profile_cubit.dart' as _i271;
import '../../features/profile/cubit/provider_request_cubit.dart' as _i1030;
import '../../features/profile/cubit/trips_cubit.dart' as _i1035;
import '../../features/profile/service_provider/cubits/provider_bookings_cubit.dart'
    as _i408;
import '../../features/profile/service_provider/cubits/provider_dashboard_cubit.dart'
    as _i505;
import '../../features/profile/service_provider/cubits/provider_services_cubit.dart'
    as _i743;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final getItModule = _$GetItModule();
    gh.singleton<_i361.BaseOptions>(() => getItModule.baseOptions);
    gh.singleton<_i528.PrettyDioLogger>(() => getItModule.prettyDioLogger);
    gh.singleton<_i394.ApiServices>(() => getItModule.apiservices);
    gh.factory<_i453.TripsRemoteDataSource>(
      () => _i357.TripsRemoteDataSourceImpl(gh<_i394.ApiServices>()),
    );
    gh.factory<_i249.ProfileRemoteDataSource>(
      () => _i498.ProfileRemoteDataSourceImpl(gh<_i394.ApiServices>()),
    );
    gh.factory<_i73.Authremotedatasource>(
      () => _i677.AuthRemoteDatasrcImpl(gh<_i394.ApiServices>()),
    );
    gh.singleton<_i361.Dio>(
      () => getItModule.provideDio(
        gh<_i361.BaseOptions>(),
        gh<_i528.PrettyDioLogger>(),
      ),
    );
    gh.factory<_i867.ProviderRemoteDataSource>(
      () => _i765.ProviderRemoteDataSourceImpl(gh<_i394.ApiServices>()),
    );
    gh.factory<_i832.TripsRepoContract>(
      () => _i609.TripsRepositoryImpl(gh<_i453.TripsRemoteDataSource>()),
    );
    gh.factory<_i482.AuthRepoContract>(
      () => _i554.Authrepositoryimpl(gh<_i73.Authremotedatasource>()),
    );
    gh.factory<_i347.AddActivityUseCase>(
      () => _i347.AddActivityUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i402.CreateTripUseCase>(
      () => _i402.CreateTripUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i423.DeleteActivityUseCase>(
      () => _i423.DeleteActivityUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i614.DeleteTripUseCase>(
      () => _i614.DeleteTripUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i91.GetTripByIdUseCase>(
      () => _i91.GetTripByIdUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i605.GetTripsUseCase>(
      () => _i605.GetTripsUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i211.UpdateTripUseCase>(
      () => _i211.UpdateTripUseCase(gh<_i832.TripsRepoContract>()),
    );
    gh.factory<_i869.ProviderRepoContract>(
      () => _i946.ProviderRepositoryImpl(gh<_i867.ProviderRemoteDataSource>()),
    );
    gh.factory<_i974.ProfileRepoContract>(
      () => _i1071.ProfileRepositoryImpl(gh<_i249.ProfileRemoteDataSource>()),
    );
    gh.factory<_i769.GetProviderDashboardUseCase>(
      () => _i769.GetProviderDashboardUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.GetProviderServicesUseCase>(
      () => _i517.GetProviderServicesUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.UpdateServiceUseCase>(
      () => _i517.UpdateServiceUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.DeleteServiceUseCase>(
      () => _i517.DeleteServiceUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.GetProviderBookingsUseCase>(
      () => _i517.GetProviderBookingsUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.UpdateBookingStatusUseCase>(
      () => _i517.UpdateBookingStatusUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.ConfirmBookingUseCase>(
      () => _i517.ConfirmBookingUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.DeclineBookingUseCase>(
      () => _i517.DeclineBookingUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.CompleteBookingUseCase>(
      () => _i517.CompleteBookingUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.ContactBookingUseCase>(
      () => _i517.ContactBookingUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.GetProviderEarningsUseCase>(
      () => _i517.GetProviderEarningsUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.SubmitProviderRequestUseCase>(
      () =>
          _i517.SubmitProviderRequestUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i517.GetMyProviderRequestUseCase>(
      () => _i517.GetMyProviderRequestUseCase(gh<_i869.ProviderRepoContract>()),
    );
    gh.factory<_i408.ProviderBookingsCubit>(
      () => _i408.ProviderBookingsCubit(
        gh<_i517.GetProviderBookingsUseCase>(),
        gh<_i517.ConfirmBookingUseCase>(),
        gh<_i517.DeclineBookingUseCase>(),
        gh<_i517.CompleteBookingUseCase>(),
        gh<_i517.ContactBookingUseCase>(),
      ),
    );
    gh.factory<_i1035.TripsCubit>(
      () => _i1035.TripsCubit(
        gh<_i605.GetTripsUseCase>(),
        gh<_i91.GetTripByIdUseCase>(),
        gh<_i402.CreateTripUseCase>(),
        gh<_i211.UpdateTripUseCase>(),
        gh<_i614.DeleteTripUseCase>(),
        gh<_i347.AddActivityUseCase>(),
        gh<_i423.DeleteActivityUseCase>(),
      ),
    );
    gh.factory<_i175.LoginInUseCase>(
      () => _i175.LoginInUseCase(gh<_i482.AuthRepoContract>()),
    );
    gh.factory<_i870.SignUpUseCase>(
      () => _i870.SignUpUseCase(gh<_i482.AuthRepoContract>()),
    );
    gh.factory<_i1020.GetSavedPlacesUseCase>(
      () => _i1020.GetSavedPlacesUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i311.GetUsernameUseCase>(
      () => _i311.GetUsernameUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i539.GetVisitedPlacesUseCase>(
      () => _i539.GetVisitedPlacesUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i415.SavePlaceUseCase>(
      () => _i415.SavePlaceUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i149.UnsavePlaceUseCase>(
      () => _i149.UnsavePlaceUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i316.VisitPlaceUseCase>(
      () => _i316.VisitPlaceUseCase(gh<_i974.ProfileRepoContract>()),
    );
    gh.factory<_i369.RegisetrViewModel>(
      () => _i369.RegisetrViewModel(gh<_i870.SignUpUseCase>()),
    );
    gh.factory<_i271.ProfileCubit>(
      () => _i271.ProfileCubit(
        gh<_i311.GetUsernameUseCase>(),
        gh<_i1020.GetSavedPlacesUseCase>(),
        gh<_i539.GetVisitedPlacesUseCase>(),
        gh<_i415.SavePlaceUseCase>(),
        gh<_i149.UnsavePlaceUseCase>(),
        gh<_i316.VisitPlaceUseCase>(),
        gh<_i605.GetTripsUseCase>(),
      ),
    );
    gh.factory<_i505.ProviderDashboardCubit>(
      () => _i505.ProviderDashboardCubit(
        gh<_i769.GetProviderDashboardUseCase>(),
        gh<_i517.GetProviderEarningsUseCase>(),
      ),
    );
    gh.factory<_i743.ProviderServicesCubit>(
      () => _i743.ProviderServicesCubit(
        gh<_i517.GetProviderServicesUseCase>(),
        gh<_i517.UpdateServiceUseCase>(),
        gh<_i517.DeleteServiceUseCase>(),
      ),
    );
    gh.factory<_i959.Loginviewmodel>(
      () => _i959.Loginviewmodel(gh<_i175.LoginInUseCase>()),
    );
    gh.factory<_i1030.ProviderRequestCubit>(
      () => _i1030.ProviderRequestCubit(
        gh<_i517.GetMyProviderRequestUseCase>(),
        gh<_i517.SubmitProviderRequestUseCase>(),
      ),
    );
    return this;
  }
}

class _$GetItModule extends _i878.GetItModule {}
