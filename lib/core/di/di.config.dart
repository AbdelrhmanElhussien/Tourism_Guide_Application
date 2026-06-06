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
import '../../api/dio/get_It_module.dart' as _i878;
import '../../data/data_sources/remot/auth/authRemoteDataSource.dart' as _i73;
import '../../data/repoitores/auth/authRepositoryImpl.dart' as _i554;
import '../../domain/repositories/auth/authRepoContract.dart' as _i482;
import '../../domain/use_cases/loginInUseCase.dart' as _i175;
import '../../domain/use_cases/signUpUseCase.dart' as _i870;
import '../../features/AppScreens/auth_screen/Login/cubit/loginViewModel.dart'
    as _i503;
import '../../features/AppScreens/auth_screen/signUp/cubit/regisetrViewModel.dart'
    as _i477;

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
    gh.factory<_i73.Authremotedatasource>(
      () => _i677.AuthRemoteDatasrcImpl(gh<_i394.ApiServices>()),
    );
    gh.singleton<_i361.Dio>(
      () => getItModule.provideDio(
        gh<_i361.BaseOptions>(),
        gh<_i528.PrettyDioLogger>(),
      ),
    );
    gh.factory<_i482.AuthRepoContract>(
      () => _i554.Authrepositoryimpl(gh<_i73.Authremotedatasource>()),
    );
    gh.factory<_i175.LoginInUseCase>(
      () => _i175.LoginInUseCase(gh<_i482.AuthRepoContract>()),
    );
    gh.factory<_i870.SignUpUseCase>(
      () => _i870.SignUpUseCase(gh<_i482.AuthRepoContract>()),
    );
    gh.factory<_i477.RegisetrViewModel>(
      () => _i477.RegisetrViewModel(gh<_i870.SignUpUseCase>()),
    );
    gh.factory<_i503.Loginviewmodel>(
      () => _i503.Loginviewmodel(gh<_i175.LoginInUseCase>()),
    );
    return this;
  }
}

class _$GetItModule extends _i878.GetItModule {}
