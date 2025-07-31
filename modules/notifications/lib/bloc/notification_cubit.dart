import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/service/notification_service.dart';

class NotificationCubit extends Cubit<NotificationState?> {
  NotificationCubit() : super(null);

  void showNotification({
    String? message,
    required NotificationStatus status,
  }) {
    emit(
      message?.isEmpty ?? true
          ? null
          : NotificationState(
              message: message,
              status: status,
            ),
    );
  }

  void clearNotification() {
    emit(null);
  }
}

class NotificationState {
  final String? message;
  final NotificationStatus status;

  NotificationState({
    required this.message,
    required this.status,
  });
}
