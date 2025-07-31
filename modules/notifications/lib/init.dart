import 'package:notifications/bloc/notification_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:notifications/service/notification_service.dart';

class NotificationsInit {
  static Future<void> initialize(GetIt getIt) async {
    //Cubits
    getIt.registerSingleton(NotificationCubit());

    //Services
    getIt.registerLazySingleton(() => NotificationService(getIt()));
  }
}
