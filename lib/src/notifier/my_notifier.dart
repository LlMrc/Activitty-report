import 'package:flutter/material.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/student.dart';

class PyonyeNotifier with ChangeNotifier {
  bool? _isPyonye; // This holds the boolean value
  bool isExpanded = false; // Track whether the ExpansionTile is expanded
  bool? get isPyonye => _isPyonye;

  List<bool> _expansionStates = []; // Initialized as a growable list

  // Increment the lesson count for the student
  void increment(Student student) async {
    // Retrieve the current count from the student's lesson field
    int currentCount = student.lesson ?? 0;

    // Increment the lesson count
    student.lesson = currentCount + 1;

    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateStudent(student);

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Decrement the lesson count for the student
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

  // Update the timer for the student
  void updateTimer(Duration timer) async {
    // Save the updated timer back to SharedPreferences
    await SharedPreferencesSingleton().updateTimerMinutAndHour(timer);

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Initialize the list dynamically based on the item count
  void initializeExpansionStates(int length) {
    // Ensure the list is growable and initialized to the correct length
    if (_expansionStates.length != length) {
      _expansionStates = List.filled(length, false, growable: true);

      // Ensure notifyListeners is called after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  // Check whether a particular item is expanded
  bool isExpand(int index) {
    return _expansionStates[index];
  }

  // Toggle the expansion state for a particular item
  void toggleExpansion(bool value, int index) {
    if (index < _expansionStates.length) {
      _expansionStates[index] = value;
      notifyListeners();
    }
  }

  // Add a new student and manage the expansion state
  Future<void> addStudent(Student student) async {
    // Save the student to SharedPreferences or any storage
    await SharedPreferencesSingleton().addStudent(student);

    // Add a default expansion state for the new student
    _expansionStates.add(false);

    // Notify listeners to update the UI
    notifyListeners();
  }
}
