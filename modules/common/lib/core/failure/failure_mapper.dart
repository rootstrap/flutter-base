import 'package:dio/dio.dart';

import 'failure.dart';

extension FailureMapper on DioError {
  Failure toFailure() {
    switch (type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return SocketTimeOutFailure(message);
      case DioErrorType.badResponse:
        return HttpFailure(response?.statusCode, name: message);
      case DioErrorType.cancel:
      case DioErrorType.unknown:
      case DioErrorType.badCertificate:
      case DioErrorType.connectionError:
        return UnexpectedFailure(message);
    }
  }
}
