import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:report/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../local/local.dart';
import '../../model/event.dart';

class ReportNification {
  static Future<void> initNotification() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Set up Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Ensure you have an app icon

    // Set up iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combine all platform initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    // Initialize the plugin with the settings
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? payload) async {
        // Handle notification tap (optional)
        if (payload != null) {
          print('Notification payload: $payload');
        }
      },
    );
  }

  static Future<bool> requestPermissions() async {
    bool? grantedNotificationPermission;
    if (Platform.isIOS || Platform.isMacOS) {
      // Request permissions for iOS and macOS
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      // Request permissions for Android
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
    }
    return grantedNotificationPermission ?? false;
  }

  static void showEventAlarm() async {
    Map<DateTime, List<Event>> map = SharedPreferencesSingleton().getEvents();
    var eventList = map.keys.toList();

    for (var date in eventList) {
      for (var event in map[date]!) {
        await _scheduleLocalEventNotification(
            event: event, scheduledDate: date);
      }
    }
  }

  // Show event in local notification
  static Future<void> _scheduleLocalEventNotification(
      {required Event event, required DateTime scheduledDate}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
      channelShowBadge: true,
      color: Color.fromARGB(255, 15, 247, 138),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      ),
    );
    tz.TZDateTime scheduleTime = tz.TZDateTime.from(scheduledDate, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      event.title,
      event.description,
      scheduleTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: '1',
    );
  }
}
