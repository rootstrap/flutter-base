import 'package:flutter_base_rootstrap/repository/data_source/remote/network/http_client.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/utils/resource.dart';

abstract class SkeletonDataSource {
  Future<Resource<bool, CustomException>> checkServerStatus();
}

class SkeletonDataSourceImpl extends SkeletonDataSource {
  @override
  Future<Resource<bool, CustomException>> checkServerStatus() async {
    try {
      final response = await HttpClient(path: 'status').get();

      if (response.isSuccess) {
        return Success(response.isSuccess);
      }

      return Success(false);
    } catch (e) {
      return Failure(CustomException(e.toString()));
    }
  }
}
