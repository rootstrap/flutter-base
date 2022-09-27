import 'package:flutter_base_rootstrap/repository/data_source/remote/concret/remote_ds_class.dart';

abstract class RemoteDsExample {
  //Example until having dependency injection
  static final RemoteDsExample instance = RemoteDsExampleImpl();

  Future<bool> isAppActivate();
}
