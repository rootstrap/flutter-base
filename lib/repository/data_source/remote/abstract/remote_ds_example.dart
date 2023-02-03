import 'package:flutter_base_rootstrap/repository/data_source/remote/concrete/remote_ds_example_impl.dart';

abstract class RemoteDsExample {
  //Example until having dependency injection
  static final RemoteDsExample instance = RemoteDsExampleImpl();

  Future<bool> isAppActivate();
}
