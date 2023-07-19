import 'package:dio/dio.dart';

import 'network_constants.dart';

class NetworkConfig {
  static Dio provideDio() {
    final options = BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: const Duration(
        seconds: NetworkConstants.connectTimeout,
      ),
      receiveTimeout: const Duration(
        seconds: NetworkConstants.receiveTimeout,
      ),
    );
    return Dio(options);
  }
}
