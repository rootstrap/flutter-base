part of 'skeleton_cubit.dart';

class SkeletonState extends Equatable {
  final bool isOnline;
  final CubitStatus status;
  final String? error;

  const SkeletonState({
    required this.isOnline,
    required this.status,
    this.error,
  });

  factory SkeletonState.initial() {
    return const SkeletonState(
      isOnline: false,
      status: CubitStatus.initial,
    );
  }

  SkeletonState copyWith({
    bool? isOnline,
    CubitStatus? status,
    String? error,
  }) {
    return SkeletonState(
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isOnline, status, error];
}
