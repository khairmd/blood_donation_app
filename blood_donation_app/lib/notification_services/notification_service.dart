// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // final FlutterLocalNotificationsPlugin _notificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    // const androidSettings= AndroidInitializationSettings('@mipmap/ic_launcher'); // fallback to app icon


    // final iosSettings = DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );

    // final initializationSettings = InitializationSettings(
    //   android: androidSettings,
    //   iOS: iosSettings,
    // );
    //
    // await _notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (NotificationResponse response) async {
    //     // Optional: handle notification tap
    //   },
    // );
  }

  // Future<void> showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   NotificationDetails? payload,
  // }) async {
  //   await _notificationsPlugin.show(id, title, body, payload);
  // }
}
