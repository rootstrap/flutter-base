import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';
import 'package:flutter_base_rootstrap/repository/abstract/repository_class.dart';
import 'package:flutter_base_rootstrap/utils/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceExampleImpl extends ServiceExample {
  final _blocServerStatus = _ServerStateCubit();

  @override
  Cubit<Data<bool>> get blocServerStatus => _blocServerStatus;

  @override
  void checkState() async => _blocServerStatus.checkServerState();
}

class _ServerStateCubit extends Cubit<Data<bool>> {
  _ServerStateCubit() : super(Data(data: false));

  void checkServerState() async {
    _isLoading();
    _notifyData(await RepositoryExample.instance.isServerOnline());
  }

  void _isLoading() => emit(Data(isLoading: true));

  void _notifyData(bool isServerOnline) => emit(
        Data(
          isLoading: false,
          data: isServerOnline,
        ),
      );
}
