import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/my_notifier.dart';
import 'package:report/src/notifier/time_notifier.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'src/app.dart';
import 'src/local/local.dart';
import 'src/notifier/repport_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesSingleton().init();
  // Initialize timezone and notifications
  tz.initializeTimeZones();

  runApp(MultiProvider(
      providers:  [
       ChangeNotifierProvider<PyonyeNotifier>(create: (context)=> PyonyeNotifier()),
      ChangeNotifierProvider<RepportNotifier>(create: (context) => RepportNotifier()),
      ChangeNotifierProvider<TimerNotifier>(create: (context) => TimerNotifier()),
      ],
      child: const MyApp()));
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
