import 'package:flutter_base_rootstrap/domain/services/abstract/service_class.dart';
import 'package:flutter_base_rootstrap/repository/abstract/repository_class.dart';

class ServiceExampleImpl extends ServiceExample {
  bool _isActive = false;

  final RepositoryExample _repositoryExample;

  ServiceExampleImpl(this._repositoryExample);

  @override
  void activateApp() {
    // TODO: do something
    _isActive = true;
  }

  @override
  bool get isActive => _isActive;
}
