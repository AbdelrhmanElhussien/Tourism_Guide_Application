import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tourist_app/api/api_constant.dart';
import 'package:tourist_app/api/api_services.dart';
import 'package:tourist_app/api/dio/dio_interceptors.dart';

@module
abstract class GetItModule {
  @singleton
  BaseOptions get baseOptions => BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    receiveTimeout: Duration(seconds: 5),
    sendTimeout: Duration(seconds: 5),
    // headers:
    // responseType:
    // validateStatus:
  );
  @singleton
  PrettyDioLogger get prettyDioLogger => PrettyDioLogger(
    requestHeader: true,
    responseHeader: true,
    responseBody: true,
    requestBody: true,
    error: true,
    request: true,
  );
  @singleton
  Dio provideDio(BaseOptions baseOptions, PrettyDioLogger prettyDioLogger) {
    var dio = Dio(baseOptions);
    dio.interceptors.add(DioInterceptor());
    dio.interceptors.add(PrettyDioLogger());
    return dio;
  }

  @singleton
  ApiServices get apiservices =>
      ApiServices(provideDio(baseOptions, prettyDioLogger));
}

//todo : api Services => Dio
//todo : Dio => baseOptions , PretyyDiologger , Interseptors
//
