import 'package:flutter_base_rootstrap/skeleton/data/data_sources/skeleton_data_source.dart';
import 'package:flutter_base_rootstrap/skeleton/domain/repositories/skeleton_repository.dart';
import 'package:flutter_base_rootstrap/utils/custom_exception.dart';
import 'package:flutter_base_rootstrap/utils/resource.dart';

class SkeletonRepositoryImpl extends SkeletonRepository {
  final SkeletonDataSource _skeletonDataSource;

  SkeletonRepositoryImpl(this._skeletonDataSource);

  @override
  Future<Resource<bool, CustomException>> checkServerStatus() async {
    return await _skeletonDataSource.checkServerStatus();
  }
}
