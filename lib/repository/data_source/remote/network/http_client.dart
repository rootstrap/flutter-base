import 'package:dio/dio.dart';
import 'package:flutter_base_rootstrap/repository/data_source/local/abstract/preferences.dart';

class HttpClient {
  late Dio _dio;
  String baseUrl;
  final String path;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? parameters;
  final int? connectTimeOut;
  final int? receiveTimeout;
  static const defaultTimeout = 10000;
  static const defaultBaseUrl = 'target-mvd-api.herokuapp.com';
  static const defaultReceiveTimeout = 10000;

  Uri get _url => Uri.https(baseUrl, '/api/v1/$path');

  Map<String, dynamic> get _headers {
    final defaultHeaders = <String, dynamic>{
      'Content-Type': 'application/json'
    };

    if (headers != null) {
      defaultHeaders.addAll(headers!);
    }

    defaultHeaders.addAll(Preferences.instance.secureHeaders);

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
        headers: _headers,
      ),
    );
  }

  Future<HttpResponse> get() => _processResponse(_dio.get(_url.path));

  Future<HttpResponse> post() =>
      _processResponse(_dio.post(_url.path, data: parameters));

  Future<HttpResponse> patch() =>
      _processResponse(_dio.patch(_url.path, data: parameters));

  Future<HttpResponse> delete() =>
      _processResponse(_dio.delete(_url.path, data: parameters));

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
        Preferences.instance.secureHeaders =
            savedHeaders as Map<String, String>;
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

  bool get isSuccess => exception == null;
}

extension UtilResponse on Response {
  bool get isSuccess => statusCode! >= 200 && statusCode! < 300;
}

class HttpError {
  final int? errorCode;
  final String? message;

  const HttpError({this.errorCode, this.message});
}
