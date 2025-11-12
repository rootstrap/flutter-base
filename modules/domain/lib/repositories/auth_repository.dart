import 'dart:async';

import 'package:common/core/result_type.dart';

abstract class AuthRepository {
  bool isLoggedIn();

  Future<ResultType<void>> login(String username, String password);

  Future<void> logout();
}
