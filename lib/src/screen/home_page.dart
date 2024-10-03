import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:report/src/feature/student/student_tile.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/notifier/repport_notifier.dart';
import 'package:report/src/notifier/time_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/report.dart';
import '../model/timer.dart';
import '../notification/local_notification.dart';
import '../shape/custom_shape.dart';
import '../model/modules.dart';
import '../feature/calender/calender.dart';
import '../feature/notes/note_screen.dart';
import '../feature/student/add_students.dart';
import '../widget/drawer.dart';
import '../widget/timer/stopwatch.dart';
import 'widget/bottom_icon.dart';

Widget buildItem(Modules item, BuildContext context) {
  return InkWell(
    key: Key(item.id.toString()),
    onTap: () {
      Navigator.restorablePushNamed(
        context,
        item.routeName,
      );
    },
    child: Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(width: 50, height: 50, item.imagePath),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.items = const [
      Modules(
          1,
          'assets/images/user.png',
          'Etidyan',
          AddStudentScreen
              .routeName), //<a href="https://www.flaticon.com/free-icons/add" title="add icons">Add icons created by Freepik - Flaticon</a>
      Modules(
          2,
          'assets/images/note.png',
          'Nòt',
          NoteScreen
              .routeName), //<a href="https://www.flaticon.com/free-icons/add" title="add icons">Add icons created by Pixel perfect - Flaticon</a>
      Modules(
          3, 'assets/images/calendar.png', 'Ajanda', CalenderScreen.routeName)
    ], //<a href="https://www.flaticon.com/free-icons/agenda" title="agenda icons">Agenda icons created by Freepik - Flaticon</a>
  });

  static const routeName = '/';

  final List<Modules> items;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repport? repport;

  @override
  void initState() {
    super.initState();
    checkForMonthlyReport();
    repport = _preference.getRepport();
  }

  bool started = false;

  @override
  Widget build(BuildContext context) {
    final timeNotifier = Provider.of<TimerNotifier>(context);
    final repportListener = context.watch<RepportNotifier>();
    if (repportListener.refresh) refreshThisPage();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        timeNotifier.saveTimer();
        if (timeNotifier.getStarted) ReportNification.showLocalNotification();
      },
      child: Scaffold(
        endDrawer: const RepoDrawer(),
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            /// background image
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                image: const DecorationImage(
                                  image: AssetImage('assets/bg.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Stack(
                              children: [
                                CustomPaint(
                                  painter: CardPaint(),
                                  size: const Size(600, 200),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 20,
                                  child: Consumer<RepportNotifier>(
                                      builder: (context, notifier, _) {
                                    return SizedBox(
                                        width: 200,
                                        child: repport?.isPyonye == true
                                            ? const StopwatchWidget()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                      height: 60,
                                                      width: 60,
                                                      'assets/svg/welcome.svg'),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .welcomeMessage, //Yon solisyon efikas pou jere epi swiv tout aktivite\'w yo
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .surfaceContainerHigh,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 2,
                                                        ),
                                                  ),
                                                ],
                                              ));
                                  }),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                onPressed: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.items
                        .map((item) => buildItem(item, context))
                        .toList(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),
                const StudentListTile(),
              ],
            );
          },
        ),
        extendBody: true,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        floatingActionButton:
            Consumer<RepportNotifier>(builder: (context, n, _) {
          if (repport?.isPyonye == true) {
            return Consumer<TimerNotifier>(builder: (context, timer, child) {
              return FloatingActionButton(
                  onPressed: () {
                    timer.toggleStarted();
                    timer.getStarted ? timer.stopTimer() : timer.startTimer();
                  },
                  child: timer.getStarted
                      ? const Icon(Icons.timer_outlined)
                      : const Icon(Icons.timer_off_outlined));
            });
          } else {
            return const SizedBox.shrink();
          }
        }),
        bottomNavigationBar:
            Consumer<RepportNotifier>(builder: (context, isPyonye, _) {
          if (repport?.isPyonye == true) {
            return Consumer<TimerNotifier>(builder: (context, notifier, _) {
              return BottomAppBar(
                padding: const EdgeInsets.symmetric(vertical: 0),
                shape: const CircularNotchedRectangle(),
                height: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BottomAppBarIcon(
                      icon: Icons.delete,
                      label: 'Delete',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => deleteDialog(context));
                      },
                    ),
                    BottomAppBarIcon(
                      icon: Icons.refresh,
                      label: 'Reset',
                      onPressed: () {
                        notifier.resetTimer();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            content: Text(AppLocalizations.of(context)!
                                .resetCounter))); //'kontè a rekòmanse a zero!'
                      },
                    ),
                    BottomAppBarIcon(
                      icon: Icons.save,
                      label: 'Save',
                      onPressed: () {
                        notifier.saveTimer();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            content: Text(AppLocalizations.of(context)!
                                .timerCount))); //'Ou anrejistre lè a!'
                      },
                    )
                  ],
                ),
              );
            });
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }

  deleteDialog(BuildContext context) {
    return AlertDialog.adaptive(
      iconColor: Theme.of(context).colorScheme.error,
      icon: const Icon(Icons.question_mark),
      content: Text(AppLocalizations.of(context)!
          .cancelPionner
          .toUpperCase()), //Ou vle anile sevis pyonye a ?
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.no, // 'Non',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (repport != null) {
                var newRepport = repport!.copyWith(isPyonye: false);
                _preference.updateRepport(newRepport);
                setState(() => repport = newRepport);
              }
            },
            child: Text(
              AppLocalizations.of(context)!.yes, //'Wi',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            )),
      ],
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

  Future<void> _addRepport() async {
    var currentRapport = _preference.getAllRepports();
    // Get all students and reports from the _preference

    var students = await _preference.getAllStudents();
    var repport = getTotalPublicationAndVizit();
    var duration = getTotalDuration();
    var time = _preference.getAllTimers();

    final newRepport = Repport(
      time: '${duration.inHours}:${duration.inMinutes.remainder(60)}',
      publication: repport.isNotEmpty ? repport['totalPublication'] : 0,
      vizit: repport.isNotEmpty ? repport['totalVizit'] : 0,
      name: currentRapport.first.name,
      student: students.length,
      comment: 'Rapport du mois',
      isPyonye: false,
      isSubmited: true,
      submitAt: currentRapport.last.submitAt,
    );
    await _preference.saveRepport(newRepport);
    await _preference.deleteUnsubmitedReport();
    currentRapport.clear();
    time.clear();
  }

  void checkForMonthlyReport() {
    DateTime now = DateTime.now();
    if (now.day == 1) {
      _addRepport(); // Run the report at the start of the month
    }
  }

  void refreshThisPage() {
    setState(() {
      repport = _preference.getRepport();
    });
  }

  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();
}
