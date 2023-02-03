import 'package:flutter_base_rootstrap/repository/abstract/repository_example.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/abstract/remote_ds_example.dart';

class RepositoryExampleImpl extends RepositoryExample {
  final RemoteDsExample _remoteDsExample;

  RepositoryExampleImpl(this._remoteDsExample);

  @override
  Future<bool> isServerOnline() async => await _remoteDsExample.isAppActivate();
}
