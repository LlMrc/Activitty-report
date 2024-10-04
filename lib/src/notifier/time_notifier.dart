import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'dart:async';

import '../model/timer.dart';

class TimerNotifier extends ChangeNotifier {
  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();

  Timer? timer;
  bool _isStarted = false;
  bool _isReset = false;
  Duration _duration; // Remove the initialization here

  bool get getStarted => _isStarted;
  // bool get reset => _isReset;

  void toggleStarted() {
    if (_isStarted) {
      stopTimer();
    } else {
      startTimer();
    }
    notifyListeners(); // Notify listeners after toggling
  }

  void didReset() {
    _isReset = true;
    _isStarted = false;
    notifyListeners();
  }

  void didNotReset() {
    _isReset = false;
    notifyListeners();
  }

  TimerNotifier()
      : _duration = _timerPreferences(); // Initialize in the constructor

  Duration get duration => _duration;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    _isStarted = true;
  
  }

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel(); // Only stop the timer without resetting _duration
      // _preference.updateTimerMinutAndHour(_duration);

      // // Save the updated timer state
      // _preference.saveTimer(TimerModel(
      //     hour: _duration.inHours,
      //     minut: _duration.inMinutes
      //         .remainder(60), // Fix the minute to be in the range of 0-59
      //     day: DateTime.now().day,
      //     isReset: false,
      //     timeOfDay: TimeOfDay.now()));
    }
    _isStarted = false;
  }

  void resetTimer() {
    _duration = const Duration(); // Reset the timer to zero
    _preference.updateTimerMinutAndHour(_duration);
    _preference.saveTimer(TimerModel(
        hour: _duration.inHours,
        minut: _duration.inMinutes
            .remainder(60), // Fix the minute to be in the range of 0-59
        day: DateTime.now().day,
        isReset: true,
        timeOfDay: TimeOfDay.now()));
    didReset();
    notifyListeners(); // Notify listeners about the change
    _isStarted = false;
  }

  void saveTimer() {
    _preference.saveTimer(TimerModel(
        hour: _duration.inHours,
        minut: _duration.inMinutes
            .remainder(60), // Fix the minute to be in the range of 0-59
        day: DateTime.now().day,
        isReset: _isReset,
        timeOfDay: TimeOfDay.now()));
    _duration = const Duration(); // Reset the timer to zero

  
    notifyListeners(); // Notify listeners about the change
    _isStarted = false;
  }

  void addTime() {
    _duration += const Duration(seconds: 1); // Increment the duration
    notifyListeners(); // Notify listeners about the change
  }

  static Duration _timerPreferences() {
    final TimeOfDay now = TimeOfDay.now();

    // Get saved timer from SharedPreferences
    TimerModel? time = SharedPreferencesSingleton().getTimer();
    DateTime date = DateTime.now();

    if (time != null && time.isReset) {
      // Initialize the duration based on the saved hours and minutes
      return Duration(
          hours: time.hour ?? 0, // Fallback to 0 if `hour` is null
          minutes: time.minut);
    }

   

    if (time != null && !time.isReset) {
      // Sum the current time with the saved time
      final sub = subtractTimeOfDay(now, time.timeOfDay);
      return Duration(
          hours: (time.hour ?? 0) + sub.hour, minutes: time.minut + sub.minute);
    } else {
      // If no time exists in storage, create a default TimerModel and duration
      var initTime = TimerModel(
          hour: 0,
          minut: 0,
          day: date.day,
          isReset: false,
          timeOfDay: TimeOfDay.now());

      return Duration(hours: initTime.hour ?? 0, minutes: initTime.minut);
    }
  }

  static TimeOfDay subtractTimeOfDay(TimeOfDay t1, TimeOfDay t2) {
    // Convert TimeOfDay to Duration
    final t1Duration = Duration(hours: t1.hour, minutes: t1.minute);
    final t2Duration = Duration(hours: t2.hour, minutes: t2.minute);

    // Subtract the two durations
    final totalDuration = t1Duration - t2Duration;

    // Ensure the result is within a 24-hour format
    final totalMinutes = totalDuration.inMinutes % (24 * 60);

    // Handle negative durations by adding 24 hours if needed
    final wrappedMinutes =
        totalMinutes.isNegative ? totalMinutes + (24 * 60) : totalMinutes;

    // Convert the total minutes back to TimeOfDay
    final result = TimeOfDay(
      hour: wrappedMinutes ~/ 60, // Integer division to get hours
      minute: wrappedMinutes % 60, // Remainder to get minutes
    );

    return result;
  }
}
