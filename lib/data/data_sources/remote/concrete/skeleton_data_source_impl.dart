import 'package:flutter_base_rootstrap/data/data_sources/network/http_client.dart';
import 'package:flutter_base_rootstrap/skeleton/data/data_sources/remote/abstract/skeleton_data_source.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/utils/resource.dart';

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
