import 'package:flutter_base_rootstrap/repository/abstract/repository_class.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/abstract/remote_ds_class.dart';

class RepositoryExampleImpl extends RepositoryExample {
  @override
  Future<bool> isServerOnline() async =>
      await RemoteDsExample.instance.isAppActivate();
}
