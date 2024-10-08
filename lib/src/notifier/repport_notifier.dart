import 'package:flutter/foundation.dart';
import 'package:report/src/local/local.dart';

import '../model/report.dart';

class RepportNotifier with ChangeNotifier {
  //*********************************************************
  Repport? getRepport() {
    final repport = SharedPreferencesSingleton().getLastRepport();
    notifyListeners();
    return repport;
  }

  bool refresh = false;

  void incrementVizit(Repport report) async {
    // Retrieve the current count from the Report model's vizit field
    int currentCount = report.vizit ?? 0;

    // Increment the hour  count
    report.vizit = currentCount + 1;

    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateRepport(report);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Function to update the boolean and notify listeners
  Future<void> saveRepportNotifier(Repport status) async {
    await SharedPreferencesSingleton().saveRepport(status);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future<void> repportPyonyeNotifier() async {
    Repport? repport = SharedPreferencesSingleton().getLastRepport();
    if (repport != null) {
      final nwRepport = repport.copyWith(isPyonye: true);
      await SharedPreferencesSingleton().updateRepport(nwRepport);
    } else {
      repport = Repport(
          name: '',
          student: 0,
          vizit: 0,
          publication: 0,
          isPyonye: true,
          submitAt: DateTime.now());
      await SharedPreferencesSingleton().saveRepport(repport);
    }
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  // Function to update the boolean and notify listeners
  Future<void> updateRepportNotifier(Repport status) async {
    await SharedPreferencesSingleton().updateRepport(status);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void decrementVizit(Repport report) async {
    // Retrieve the current count from the Timer's minut field
    int currentCount = report.vizit ?? 0;

    // Decrement the lesson count but ensure it doesn't go below 0
    if (currentCount > 0) {
      report.vizit = currentCount - 1;
    }
    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateRepport(report);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void incrementPublication(Repport report) async {
    // Retrieve the current count from the Report model's vizit field
    int currentCount = report.publication ?? 0;

    // Increment the hour  count
    report.publication = currentCount + 1;

    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateRepport(report);

    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void decrementPublication(Repport report) async {
    // Retrieve the current count from the Timer's minut field
    int currentCount = report.publication ?? 0;

    // Decrement the lesson count but ensure it doesn't go below 0
    if (currentCount > 0) {
      report.publication = currentCount - 1;
    }
    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateRepport(report);
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void refreshThisPage(bool newValue) {
    refresh = newValue;
    debugPrint('refreshThisPage called, _refresh: $refresh');

    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
