import 'package:dio/dio.dart';
import 'package:domain/env/env_config.dart';
import 'package:flutter/foundation.dart';

import '../interceptors/auth_token_interceptor.dart';
import 'network_constants.dart';

class NetworkConfig {
  static Dio provideDio(AuthTokenInterceptor? authTokenInterceptor) {
    final options = BaseOptions(
      baseUrl: EnvConfig.apiUrl,
      connectTimeout: const Duration(
        seconds: NetworkConstants.connectTimeout,
      ),
      receiveTimeout: const Duration(
        seconds: NetworkConstants.receiveTimeout,
      ),
    );

    final dio = Dio(options);

    // Add debug logging only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ));
    }

    if (authTokenInterceptor != null) {
      dio.interceptors.add(authTokenInterceptor);
    }

    return dio;
  }

  static void updateBaseUrl(Dio dio) {
    dio.options.baseUrl = EnvConfig.apiUrl;
  }
}
