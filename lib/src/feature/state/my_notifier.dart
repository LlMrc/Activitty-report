import 'package:flutter/foundation.dart';

import '../../local/local.dart';

class MyNotifier with ChangeNotifier {
  final _preferences = SharedPreferencesSingleton();
  bool _isTimerActive = false;

  void activateTimer(bool newValue) {
    _isTimerActive = newValue;
    notifyListeners();
    _preferences.upDateTimer(newValue);
  }

  bool get timer => _isTimerActive;
}
