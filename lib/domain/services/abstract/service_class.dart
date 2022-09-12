import 'package:flutter_base_rootstrap/domain/services/concrete/service_class.dart';
import 'package:flutter_base_rootstrap/utils/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ServiceExample {
  //Example until having dependency injection
  static final ServiceExample instance = ServiceExampleImpl();

  Cubit<Data<bool>> get blocServerStatus;

  void checkState();
}
