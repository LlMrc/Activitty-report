import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../local/local.dart';
import '../model/report.dart';
import '../model/student.dart';
import '../model/timer.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  static const routeName = '/history_screen';

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  List<Student> students = [];

  _loadActivity() async {
    students = await _preference.getAllStudents();
  }

  @override
  void initState() {
    _loadActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    var repport = getTotalPublicationAndVizit();
    var duration = getTotalDuration();
    final date = DateTime.now();
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myHistory.toUpperCase()),
      ),
      body: Center(
        child: SizedBox(
          height: 460,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Container(
                height: 400,
                width: 330,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: color.tertiaryContainer),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.activity.toUpperCase()),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                right: 10,
                child: Container(
                  height: 400,
                  width: 320,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: color.secondaryContainer),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      buildReportItem(
                          icon: Icons.timer_outlined,
                          text:
                              '${AppLocalizations.of(context)!.time}: ${duration.inHours}: ${duration.inMinutes.remainder(60)}'),
                      buildReportItem(
                          icon: Icons.person_add,
                          text:
                              '${AppLocalizations.of(context)!.student}: ${students.length}'),
                      buildReportItem(
                          icon: Icons.paste_outlined,
                          text:
                              '${AppLocalizations.of(context)!.publication}: ${repport.isNotEmpty ? repport['totalPublication'] : 0}'),
                      buildReportItem(
                          icon: Icons.directions_walk_rounded,
                          text:
                              '${AppLocalizations.of(context)!.visit}: ${repport.isNotEmpty ? repport['totalVizit'] : 0}'),
                      const SizedBox(height: 16),
                      Text(
                        DateFormat.yMMMEd().format(date),
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> getTotalPublicationAndVizit() {
    // Get all the reports from the _preference
    List<Repport> allRepports = _preference.getAllRepports();

    // Initialize counters for publication and vizit
    int totalPublication = 0;
    int totalVizit = 0;

    // Loop through each report and sum the publication and vizit values
    for (Repport repport in allRepports) {
      totalPublication +=
          repport.publication ?? 0; // If publication is null, add 0
      totalVizit += repport.vizit ?? 0; // If vizit is null, add 0
    }

    // Return a map containing the total values
    return {
      'totalPublication': totalPublication,
      'totalVizit': totalVizit,
    };
  }

  Duration getTotalDuration() {
    // Get all timers from the _preference
    List<TimerModel> allTimers = _preference.getAllTimers();

    // Initialize total hours and minutes
    int totalHours = 0;
    int totalMinutes = 0;

    // Loop through each TimerModel to accumulate hours and minutes
    for (TimerModel timer in allTimers) {
      totalHours += timer.hour ?? 0; // Add hours (default to 0 if null)
      totalMinutes += timer.minut; // Add minutes
    }

    // Convert extra minutes into hours
    totalHours +=
        totalMinutes ~/ 60; // Integer division to convert minutes to hours
    totalMinutes = totalMinutes % 60; // Get remaining minutes

    // Return the total duration as a Duration object
    return Duration(hours: totalHours, minutes: totalMinutes);
  }

  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();

  Widget buildReportItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        enabled: false,
        readOnly: true,
        decoration: InputDecoration(prefixIcon: Icon(icon), hintText: text),
      ),
    );
  }
}
