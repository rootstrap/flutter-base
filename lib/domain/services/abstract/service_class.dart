import 'package:flutter_base_rootstrap/utils/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ServiceExample {
  Cubit<Data<bool>> get blocServerStatus;

  void checkState();
}
