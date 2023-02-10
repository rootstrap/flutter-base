import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:flutter/foundation.dart';

import 'network_constants.dart';

class NetworkConfig {
  static Dio provideDio() {
    final options = BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.connectTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
    );
    final dio = Dio(options);
    if (kDebugMode) dio.interceptors.add(dioLoggerInterceptor);
    return dio;
  }
}
