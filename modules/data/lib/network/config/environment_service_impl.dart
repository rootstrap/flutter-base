import 'package:data/network/config/network_config.dart';
import 'package:dio/dio.dart';
import 'package:domain/env/env_config.dart';
import 'package:domain/services/environment_service.dart';

class EnvironmentServiceImpl extends EnvironmentService {
  final Dio _dio;

  EnvironmentServiceImpl(this._dio);

  @override
  void setEnvironment(String env) {
    EnvConfig.env = env;
    NetworkConfig.updateBaseUrl(_dio);
  }
}
