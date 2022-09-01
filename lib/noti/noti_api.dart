import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/subjects.dart';

class NotiApi{
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNoti = BehaviorSubject<String?>();

  /*
  * Setup the notification details
  * For Android:
  * Channel Id, Channel name, Chanel Description, Channel Importance, Channel Priority
  */

  static Future _notificationDetail() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails("0", "Reminders",
          channelDescription: "Notification Reminders",
          importance: Importance.max,
          priority: Priority.high),
      iOS: IOSNotificationDetails(),
    );
  }

  // initialize the notifications library
  static Future init({bool initSchedule = false}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = IOSInitializationSettings(requestAlertPermission: false,
        requestBadgePermission: false, requestSoundPermission: false);
    const settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    await _notification.initialize(settings,
        onSelectNotification: (payload) async {
          onNoti.add(payload);
        });

    if (initSchedule) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  // method to handle morning notification
  static Future scheduleWorkoutReminder(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        required int hr,
        min}) async =>
      _notification.zonedSchedule(id, title, body, _scheduleMorn(Time(hr, min)),
        await _notificationDetail(),
        payload: payLoad,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,);

  // method to handle evening notification
  static Future scheduleLogWorkout(
      {int id = 1,
        String? title,
        String? body,
        String? payLoad,
        required int hr,
        min}) async =>
      _notification.zonedSchedule(id, title, body, _schedule(Time(hr, min)),
          await _notificationDetail(),
          payload: payLoad,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time);

  static tz.TZDateTime _scheduleMorn(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  // method to setup recurring notifications
  static tz.TZDateTime _schedule(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }
}