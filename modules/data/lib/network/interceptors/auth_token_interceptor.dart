import 'package:dio/dio.dart';

import '../../preferences/preferences.dart';
import '../config/network_constants.dart';

class AuthTokenInterceptor extends Interceptor {
  final Preferences _preferences;

  AuthTokenInterceptor(this._preferences);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = _preferences.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers.addAll(
          {
            NetworkConstants.tokenHeader: token,
            NetworkConstants.contentTypeHeader:
                NetworkConstants.applicationJsonContentType,
          },
        );
      } else {
        await _clearCredentials();
      }
    } catch (_) {
      await _clearCredentials();
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      if (err.response?.statusCode == NetworkConstants.unauthorizedStatusCode ||
          err.response?.statusCode == NetworkConstants.forbiddenStatusCode ||
          err.response?.statusCode == NetworkConstants.invalidStatusCode) {
        _clearCredentials();
      }
    } catch (_) {
      _clearCredentials();
    }
    super.onError(err, handler);
  }

  Future<void> _clearCredentials() async {
    _preferences.clear();
  }
}
