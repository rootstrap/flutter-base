import 'package:flutter_base_rootstrap/domain/services/abstract/service_example.dart';
import 'package:flutter_base_rootstrap/repository/abstract/repository_example.dart';
import 'package:flutter_base_rootstrap/utils/data.dart';
import 'package:flutter_base_rootstrap/utils/globals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceExampleImpl extends ServiceExample {
  final _blocServerStatus = _ServerStateCubit();

  final RepositoryExample _repositoryExample;

  ServiceExampleImpl(this._repositoryExample);

  @override
  Cubit<Data<bool>> get blocServerStatus => _blocServerStatus;

  @override
  void checkState() async => _blocServerStatus.checkServerState();
}

class _ServerStateCubit extends Cubit<Data<bool>> {
  _ServerStateCubit() : super(Data());

  RepositoryExample get _repositoryExample => getIt();

  void checkServerState() async {
    _isLoading();
    _notifyData(await _repositoryExample.isServerOnline());
  }

  void _isLoading() => emit(Data(isLoading: true));

  void _notifyData(bool isServerOnline) => emit(
        Data(
          isInitial: false,
          isLoading: false,
          data: isServerOnline,
        ),
      );
}
