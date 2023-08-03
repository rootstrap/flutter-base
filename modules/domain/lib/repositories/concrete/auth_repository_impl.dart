import 'dart:async';

import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:data/preferences/preferences.dart';
import 'package:domain/models/auth_status.dart';
import 'package:domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Preferences _preferences;

  AuthRepositoryImpl(this._preferences);

  @override
  bool isLoggedIn() {
    final token = _preferences.getToken();
    return token != null;
  }

  @override
  Future<ResultType<void, Failure>> login(
    String username,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    _preferences.setToken('new-token');
    return TSuccess(null);
  }

  @override
  Future<void> logout() async {
    _preferences.setToken(null);
  }
}
