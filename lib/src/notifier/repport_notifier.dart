import 'package:flutter/foundation.dart';
import 'package:report/src/local/local.dart';

import '../model/report.dart';

class RepportNotifier with ChangeNotifier {

  //*********************************************************


  void incrementVizit(Repport report) async {
  
    // Retrieve the current count from the Report model's vizit field
    int currentCount = report.vizit ?? 0;

    // Increment the hour  count
    report.vizit = currentCount + 1;
    print(report.vizit);
    // Save the updated student back to SharedPreferences
    await SharedPreferencesSingleton().updateRepport(report);

    notifyListeners(); // Notify listeners to rebuild the UI
  }


  void decrementVizit(Repport report) async {
   
    // Retrieve the current count from the Timer's minut field
    int currentCount = report.vizit ?? 0;

    // Decrement the lesson count but ensure it doesn't go below 0
    if (currentCount > 0) {
      report.vizit = currentCount - 1;
    }
    print( report.vizit );
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
  
}