import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';

abstract class SkeletonRepository {
  Future<ResultType<bool, CustomException>> checkServerStatus();
}
