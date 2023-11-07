import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name'),
        iOS: DarwinNotificationDetails());
  }
  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('plink');

    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);
    await notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }
  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async =>
      notificationPlugin.show(id, title, body, await _notificationDetails());
}
