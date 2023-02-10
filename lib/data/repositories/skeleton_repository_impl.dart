import 'package:flutter_base_rootstrap/data/data_sources/remote/abstract/skeleton_data_source.dart';
import 'package:flutter_base_rootstrap/domain/repositories/skeleton_repository.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/core/result_type.dart';

class SkeletonRepositoryImpl extends SkeletonRepository {
  final SkeletonDataSource _skeletonDataSource;

  SkeletonRepositoryImpl(this._skeletonDataSource);

  @override
  Future<ResultType<bool, CustomException>> checkServerStatus() async {
    return await _skeletonDataSource.checkServerStatus();
  }
}
