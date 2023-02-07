import 'package:flutter_base_rootstrap/utils/resource.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';

abstract class SkeletonDataSource {
  Future<Resource<bool, CustomException>> checkServerStatus();
}
