import 'dart:async';

import 'package:flutter_base_rootstrap/core/failure/failure.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/domain/models/auth_status.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get status;

  void validate();

  Future<ResultType<void, Failure>> login(String username, String password);

  Future<void> logout();

  void dispose();
}
