import 'package:flutter_base_rootstrap/core/result_type.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';

abstract class SkeletonDataSource {
  Future<ResultType<bool, CustomException>> checkServerStatus();
}
