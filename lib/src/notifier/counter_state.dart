import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/student.dart';

class PyonyeNotifier extends ChangeNotifier {
  bool? _isPyonye; // This holds the boolean value
  int? _lessonCount;

  int? get count => _lessonCount;
  bool? get isPyonye => _isPyonye;

  // Function to update the boolean and notify listeners
  Future<void> updatePyonyeStatus(DateTime targetDate,
      {DateTime? endDate}) async {
    bool? result = await SharedPreferencesSingleton()
        .getPyonye(targetDate, endDate: endDate);
    _isPyonye = result; // Set the new value

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void increment(Student student) async {
    int currentCount =
        SharedPreferencesSingleton().getStudentCount(student) ?? 0;
    _lessonCount = currentCount + 1;
    // Update the student's count in SharedPreferences
    await SharedPreferencesSingleton().updateStudent(student);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void decrement(Student student) async {
    int currentCount =
        SharedPreferencesSingleton().getStudentCount(student) ?? 0;
    _lessonCount = currentCount > 0 ? currentCount - 1 : 0;
    await SharedPreferencesSingleton().updateStudent(student);
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
