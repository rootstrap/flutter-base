import 'package:flutter_base_rootstrap/repository/data_source/remote/abstract/remote_ds_example.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/network/http_client.dart';

class RemoteDsExampleImpl extends RemoteDsExample {
  @override
  Future<bool> isAppActivate() async {
    final response = await HttpClient(path: 'status').get();
    return response.isSuccess;
  }
}
