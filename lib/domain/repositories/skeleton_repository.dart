import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/utils/resource.dart';

abstract class SkeletonRepository {
  Future<Resource<bool, CustomException>> checkServerStatus();
}
