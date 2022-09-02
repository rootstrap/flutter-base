import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';

class ServiceExampleImpl extends ServiceExample {
  bool _isActive = false;

  @override
  void activateApp() {
    // TODO: do something
    _isActive = true;
  }

  @override
  bool get isActive => _isActive;
}
