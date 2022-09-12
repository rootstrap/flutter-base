import 'package:flutter_base_rootstrap/repository/concrete/repository_class.dart';

abstract class RepositoryExample {
  //Example until having dependency injection
  static final RepositoryExample instance = RepositoryExampleImpl();

  Future<bool> isServerOnline();
}
