import 'package:flutter/foundation.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/abstract/remote_ds_class.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/network/http_client.dart';

class RemoteDsExampleImpl extends RemoteDsExample {
  @override
  Future<bool> isAppActivate() async {
    final response = await HttpClient(path: 'status').get();
    return response.isSuccess;
  }
}
