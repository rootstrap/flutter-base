import 'package:flutter_base_rootstrap/domain/data/remote/abstract/remote_ds_class.dart';

class RemoteDsExampleImpl extends RemoteDsExample {
  @override
  Future<bool> activateApp() async {
    //TODO: setup api connection
    return true;
  }
}
