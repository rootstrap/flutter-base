import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_rootstrap/domain/repositories/skeleton_repository.dart';
import 'package:flutter_base_rootstrap/utils/cubit_status.dart';
import 'package:flutter_base_rootstrap/utils/resource.dart';

part 'skeleton_state.dart';

class SkeletonCubit extends Cubit<SkeletonState> {
  final SkeletonRepository _skeletonRepository;

  SkeletonCubit(this._skeletonRepository) : super(SkeletonState.initial());

  void checkServerStatus() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _skeletonRepository.checkServerStatus();

    result.when(
      onSuccess: (data) => emit(
        state.copyWith(isOnline: data, status: CubitStatus.success),
      ),
      onError: (error) => emit(
        state.copyWith(
          status: CubitStatus.error,
          error: error.message,
        ),
      ),
    );
  }
}
