import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:report/local.dart';
import 'package:timezone/timezone.dart' as tz;

Event eventFromJson(String str) => Event.fromJson(json.decode(str));
String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String title;
  String from;
  String? timeStamp;

  Event({required this.title, required this.from, this.timeStamp});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json["Title"],
      from: json["from"],
      timeStamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"Title": title, "from": from, "timeStamp": timeStamp};
}

class EventRepository {
// Set delay

  static void showEventAlarm() async {
    Map<DateTime, List<Event>> map = SharedPreferencesSingleton().getEvents();
    var eventList = map.keys.toList();

    for (var date in eventList) {
      for (var event in map[date]!) {
        await _scheduleLocalEventNotification(event: event, scheduleTime: date);
      }
    }
  }

  // Show event in local notification
  static Future<void> _scheduleLocalEventNotification(
      {required Event event, required DateTime scheduleTime}) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'local',
      'your channel name',
      channelDescription: 'Loacal notification',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
      channelShowBadge: true,
      icon: 'app_icon',
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

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2, // notification id
      'Event Reminder', // notification title
      event.title, // notification body
      tz.TZDateTime.from(scheduleTime, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: null, // No recurrence
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: 2.toString(),
    );
  }
}
