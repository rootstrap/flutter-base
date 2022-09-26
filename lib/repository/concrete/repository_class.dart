import 'package:flutter_base_rootstrap/repository/abstract/repository_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryExampleImpl extends RepositoryExample {
  final SharedPreferences _preferences;

  RepositoryExampleImpl(this._preferences);
}
