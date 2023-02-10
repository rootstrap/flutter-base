import 'package:flutter_base_rootstrap/data/data_sources/network/http_client.dart';
import 'package:flutter_base_rootstrap/data/data_sources/remote/abstract/skeleton_data_source.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';

class SkeletonDataSourceImpl extends SkeletonDataSource {
  @override
  Future<ResultType<bool, CustomException>> checkServerStatus() async {
    try {
      final response = await HttpClient(path: 'status').get();
      if (response.isSuccess) {
        return TSuccess(response.isSuccess);
      }
      return TSuccess(false);
    } catch (e) {
      return TError(CustomException(e.toString()));
    }
  }
}
