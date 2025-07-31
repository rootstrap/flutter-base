import 'package:notifications/bloc/notification_cubit.dart';

class NotificationService {
  final NotificationCubit _notificationCubit;

  NotificationService(this._notificationCubit);

  NotificationCubit get notificationCubit => _notificationCubit;

  void notify(String message, NotificationStatus status) {
    _notificationCubit.showNotification(message: message, status: status);
  }

  void clearNotification() {
    _notificationCubit.clearNotification();
  }
}

enum NotificationStatus {
  idle,
  information,
  success,
  error,
}
