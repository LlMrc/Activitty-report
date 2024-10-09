import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../local/local.dart';
import '../model/report.dart';
import '../model/timer.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  static const routeName = '/history_screen';

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();

  @override
  void initState() {
    super.initState();
    // _loadActivity(); // Load students asynchronously
  }

  // Future<void> _loadActivity() async {
  //   students = await _preference.getAllStudents();
  //   setState(() {}); // Trigger a rebuild after students are loaded.
  // }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    var repport = getTotalPublicationAndVizit();
    var duration = getTotalDuration();
    final date = DateTime.now();
    Repport? currentReport = _preference.getLastRepport();

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
                    AppLocalizations.of(context)!.activity.toUpperCase(),
                  ),
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
                        text: currentReport != null && currentReport.isPyonye
                            ? '${AppLocalizations.of(context)!.time}: ${duration.inHours}:${duration.inMinutes.remainder(60)}'
                            : '${AppLocalizations.of(context)!.time}: 00:00',
                      ),
                      FutureBuilder(
                          future: _preference.getAllStudents(),
                          builder: (context, snapshot) {
                            final students = snapshot.data;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            }

                            if (students == null) {
                              return buildReportItem(
                                icon: Icons.person_add,
                                text:
                                    '${AppLocalizations.of(context)!.student}: 0',
                              );
                            }
                            return buildReportItem(
                              icon: Icons.person_add,
                              text:
                                  '${AppLocalizations.of(context)!.student}: ${students.length}',
                            );
                          }),
                      buildReportItem(
                        icon: Icons.paste_outlined,
                        text: currentReport != null && currentReport.isPyonye
                            ? '${AppLocalizations.of(context)!.publication}: ${repport['totalPublication']}'
                            : '${AppLocalizations.of(context)!.publication}: 0',
                      ),
                      buildReportItem(
                        icon: Icons.directions_walk_rounded,
                        text: currentReport != null && currentReport.isPyonye
                            ? '${AppLocalizations.of(context)!.visit}: ${repport['totalVizit']}'
                            : '${AppLocalizations.of(context)!.visit}: 0',
                      ),
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
    List<Repport> allRepports = _preference.getAllRepports();

    // Initialize counters for publication and vizit
    int totalPublication = 0;
    int totalVizit = 0;

    for (Repport repport in allRepports) {
      totalPublication += repport.publication ?? 0;
      totalVizit += repport.vizit ?? 0;
    }

    return {
      'totalPublication': totalPublication,
      'totalVizit': totalVizit,
    };
  }

  Duration getTotalDuration() {
    List<TimerModel> allTimers = _preference.getAllTimers();

    int totalHours = 0;
    int totalMinutes = 0;

    for (TimerModel timer in allTimers) {
      totalHours += timer.hour ?? 0;
      totalMinutes += timer.minut;
    }

    totalHours += totalMinutes ~/ 60; // Convert minutes to hours
    totalMinutes = totalMinutes % 60;

    return Duration(hours: totalHours, minutes: totalMinutes);
  }

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
