import 'dart:async';

import 'package:common/core/failure/failure.dart';
import 'package:common/core/result_type.dart';
import 'package:domain/models/auth_status.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get status;

  void validate();

  Future<ResultType<void, Failure>> login(String username, String password);

  Future<void> logout();

  void dispose();
}
