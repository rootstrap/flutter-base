import 'package:dio/dio.dart';

class HttpClient {
  late Dio _dio;
  String baseUrl;
  final String path;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? parameters;
  final int? connectTimeOut;
  final int? recieveTimeout;
  static const defaultTimeout = 10000;
  static const defaultReceiveTimeout = 10000;

  HttpClient(
    this.baseUrl, {
    this.path = '',
    this.headers,
    this.parameters,
    this.connectTimeOut = defaultTimeout,
    this.recieveTimeout = defaultReceiveTimeout,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeOut,
      receiveTimeout: recieveTimeout,
      headers: headers,
    ));
  }

  Future<dynamic> get() async {
    var client = _dio;
    try {
      var response = await client.get(path);
      if (response.isSuccess) {
        return response;
      } else {
        throw HttpError(errorCode: response.statusCode);
      }
    } catch (e) {
      throw HttpError(message: e.toString());
    } finally {
      client.close();
    }
  }

  Future<dynamic> post() async {
    var client = _dio;
    try {
      var response = await client.post(path, data: parameters);
      if (response.isSuccess) {
        return response;
      } else {
        throw HttpError(errorCode: response.statusCode);
      }
    } catch (e) {
      throw HttpError(message: e.toString());
    } finally {
      client.close();
    }
  }

  Future<dynamic> patch() async {
    var client = _dio;
    try {
      var response = await client.patch(path, data: parameters);
      if (response.isSuccess) {
        return response;
      } else {
        throw HttpError(errorCode: response.statusCode);
      }
    } catch (e) {
      throw HttpError(message: e.toString());
    } finally {
      client.close();
    }
  }

  Future<dynamic> delete() async {
    var client = _dio;
    try {
      var response = await client.delete(path, data: parameters);
      if (response.isSuccess) {
        return response;
      } else {
        throw HttpError(errorCode: response.statusCode);
      }
    } catch (e) {
      throw HttpError(message: e.toString());
    } finally {
      client.close();
    }
  }
}

extension UtilResponse on Response {
  bool get isSuccess => statusCode! >= 200 && statusCode! < 300;
}

class HttpError {
  final int? errorCode;
  final String? message;

  const HttpError({this.errorCode, this.message});
}
