

import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/student.dart';

import '../model/report.dart';


class PyonyeNotifier with ChangeNotifier {
  bool? _isPyonye; // This holds the boolean value
   bool isExpanded = false; // Track whether the ExpansionTile is expanded
  bool? get isPyonye => _isPyonye;
  bool get pageRefresh => _refresh;

  bool _refresh = false;
  void refreshThisPage(bool newValue) {
    _refresh = newValue;
        debugPrint('refreshThisPage called, _refresh: $_refresh');

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Function to update the boolean and notify listeners
  Future<void> updatePyonyeStatus(DateTime targetDate,
      {DateTime? endDate}) async {
    bool? result = await SharedPreferencesSingleton()
        .getPyonye(targetDate, endDate: endDate);
    _isPyonye = result; // Set the new value

    notifyListeners(); // Notify listeners to rebuild the UI
  }

 void increment(Student student) async {
    // Retrieve the current count from the student's lesson field
    int currentCount = student.lesson ?? 0;

    // Increment the lesson count
    student.lesson = currentCount + 1;

    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateStudent(student);

    notifyListeners(); // Notify listeners to rebuild the UI
  }


 void decrement(Student student) async {
    // Retrieve the current count from the student's lesson field
    int currentCount = student.lesson ?? 0;

    // Decrement the lesson count but ensure it doesn't go below 0
    if (currentCount > 0) {
      student.lesson = currentCount - 1;
    }
    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateStudent(student);
    notifyListeners(); // Notify listeners to rebuild the UI
  }


  




   void updateTimer(TimeOfDay timer) async {
    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateTimerMinutAndHour(timer);

    notifyListeners(); // Notify listeners to rebuild the UI
  }



   // Toggle the expansion state
  void toggleExpansion(bool value) {
    isExpanded = value;
    notifyListeners();
  }

}
