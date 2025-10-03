import 'package:dio/dio.dart';

import 'failure.dart';

extension FailureMapper on DioException {
  Failure toFailure() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return SocketTimeOutFailure(message);
      case DioExceptionType.badResponse:
        return HttpFailure(response?.statusCode, name: message);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return UnexpectedFailure(message);
    }
  }
}
