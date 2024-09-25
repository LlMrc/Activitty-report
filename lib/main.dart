import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/counter_state.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'src/app.dart';
import 'src/local/local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesSingleton().init();
  // Initialize timezone and notifications
  tz.initializeTimeZones();

  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => PyonyeNotifier(),
      child: const MyApp()));
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
