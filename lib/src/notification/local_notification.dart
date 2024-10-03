import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:report/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import '../local/local.dart';
import '../model/event.dart';

class ReportNification {
  static Future<void> initNotification() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Set up Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Ensure you have an app icon

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
          debugPrint('Notification payload: $payload');
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
    // Retrieve single-date events
    Map<DateTime, List<Event>> map = SharedPreferencesSingleton().getEvents();
    var eventList = map.keys.toList();

    // Schedule notifications for single-date events
    for (var date in eventList) {
      for (var event in map[date]!) {
        await scheduleLocalEventNotification(event: event, scheduledDate: date);
      }
    }

    // Retrieve date-range events
    Map<List<DateTime>, Event> mapRange =
        SharedPreferencesSingleton().getEventsWithDateRange();

    // Schedule notifications for date-range events
    for (var dateRange in mapRange.keys) {
      DateTime startDate = dateRange.first;
      DateTime endDate = dateRange.last;
      var event = mapRange[dateRange];
      // Schedule notifications for each day within the date range

      if (event != null) {
        for (var date = startDate;
            date.isBefore(endDate.add(const Duration(days: 1)));
            date = date.add(const Duration(days: 1))) {
          await scheduleLocalEventNotification(
              event: event, scheduledDate: date);
        }
      }
    }
  }

  // Show event in local notification
  static Future<void> scheduleLocalEventNotification(
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
      event.comment,
      scheduleTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: event.pyonye == true
          ? DateTimeComponents.dayOfMonthAndTime
          : DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: '1',
    );
  }

  // Show local notification
  static Future showLocalNotification() async {
    // Check if notification is enabled
    bool isNotificationEnabled = SharedPreferencesSingleton().getNotification();
    if (!isNotificationEnabled) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('local', 'your channel name',
            channelDescription: 'Local notification',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: true,
            channelShowBadge: true,
            playSound: false
            // color: Color.fromARGB(255, 18, 233, 90),
            );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
      ),
    );

    await FlutterLocalNotificationsPlugin().show(
        2,
        'Notification',
        'The counter is running',
        platformChannelSpecifics, // Notifikasyon Lè a ap mache
        payload: '2');
  }
}
