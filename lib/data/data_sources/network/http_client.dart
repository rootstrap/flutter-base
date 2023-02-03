import 'package:dio/dio.dart';
import 'package:flutter_base_rootstrap/data/data_sources/local/abstract/preferences.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';

class HttpClient {
  late Dio _dio;
  String baseUrl;
  final String path;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? parameters;
  final int? connectTimeOut;
  final int? receiveTimeout;
  static const defaultTimeout = 10000;
  static const defaultBaseUrl =
      'https://target-api-induction-v2.herokuapp.com/api/v1/';
  static const defaultReceiveTimeout = 10000;

  Preferences get _pref => getIt();

  Map<String, dynamic> get _headers {
    final defaultHeaders = <String, dynamic>{
      Headers.acceptHeader: Headers.jsonContentType,
    };

    if (headers != null) {
      defaultHeaders.addAll(headers!);
    }

    defaultHeaders.addAll(_pref.secureHeaders);

    return defaultHeaders;
  }

  HttpClient({
    this.baseUrl = defaultBaseUrl,
    this.path = '',
    this.headers,
    this.parameters,
    this.connectTimeOut = defaultTimeout,
    this.receiveTimeout = defaultReceiveTimeout,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeOut,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: _headers,
      ),
    );
    _dio.interceptors.add(LogInterceptor());
  }

  Future<HttpResponse> get() => _processResponse(_dio.get(path));

  Future<HttpResponse> post() =>
      _processResponse(_dio.post(path, data: parameters));

  Future<HttpResponse> patch() =>
      _processResponse(_dio.patch(path, data: parameters));

  Future<HttpResponse> delete() =>
      _processResponse(_dio.delete(path, data: parameters));

  Future<HttpResponse> _processResponse(Future request) async {
    try {
      var response = await request;
      final remoteHeaders = response.headers;
      if (remoteHeaders.containsKey('access-token')) {
        final savedHeaders = {
          'access-token': remoteHeaders['access-token'] ?? '',
          'client': remoteHeaders['client'] ?? '',
          'expiry': remoteHeaders['expiry'] ?? '',
          'uid': remoteHeaders['uid'] ?? '',
        };
        _pref.secureHeaders = savedHeaders as Map<String, String>;
      }
      if (response.isSuccess) {
        return HttpResponse(
          data: response.data,
        );
      } else {
        return HttpResponse(
          exception: HttpError(
            errorCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return HttpResponse(
        exception: HttpError(
          message: e.toString(),
        ),
      );
    } finally {
      _dio.close();
    }
  }
}

class HttpResponse {
  final dynamic data;
  final HttpError? exception;

  const HttpResponse({this.data, this.exception});

  bool get isSuccess => exception != null;
}

extension UtilResponse on Response {
  bool get isSuccess => statusCode! >= 200 && statusCode! < 300;
}

class HttpError {
  final int? errorCode;
  final String? message;

  const HttpError({this.errorCode, this.message});
}
