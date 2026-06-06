abstract class AppException {
  String message;
  int? statusCode;
  AppException({required this.message,this.statusCode});
}
class ServerException extends AppException{
  ServerException({required super.message , super.statusCode});
}

class NetworkException extends AppException{
  NetworkException({required super.message , super.statusCode});
}

class UnexcpectedException extends AppException{
  UnexcpectedException({required super.message , super.statusCode});
}