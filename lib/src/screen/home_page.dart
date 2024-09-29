import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:report/src/feature/notification/local_notification.dart';
import 'package:report/src/notifier/my_notifier.dart';
import 'package:report/src/feature/student/student_tile.dart';
import '../local/local.dart';
import '../shape/custom_shape.dart';
import '../model/modules.dart';
import '../feature/calender/calender.dart';
import '../feature/notes/note_screen.dart';
import '../feature/student/add_students.dart';
import '../widget/drawer.dart';
import '../widget/timer/stopwatch.dart';

/// Displays a list of SampleItems.
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
          'Pran Nòt',
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
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    bool enableNotification = await ReportNification.requestPermissions();
    if (enableNotification && _preferences.getNotification()) {
      ReportNification.initNotification();
    }
  }

  final _preferences = SharedPreferencesSingleton();
  bool started = false;
  bool isPyonye = false;
  @override
  Widget build(BuildContext context) {
    // Access the notifier from the provider within the build method
    final myNotifier = Provider.of<PyonyeNotifier>(context);

    return SafeArea(
      child: Scaffold(
        endDrawer: const RepoDrawer(),
        body: Builder(builder: (context) {
          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child:   Stack(
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
                              child:  SizedBox(
                                width: 200,
                                child: isPyonye? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                        height: 60,
                                        width: 60,
                                        'assets/svg/welcome.svg'),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Solisyon efikas pou jere ak swiv aktivite ou yo byen fasil',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainerHigh,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 2),
                                    ),
                                  ],
                                )
                                      : const StopwatchWidget(),
                              ) ,
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.settings,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.items
                      .map((item) => buildItem(item, context))
                      .toList()),
              const SizedBox(height: 10),
              const StudentListTile()
            ],
          );
        }),
        floatingActionButton: AnimatedOpacity(
          duration: Durations.medium1,
          opacity: myNotifier.isPyonye == true ? 1.0 : 0.0,
          child: FloatingActionButton(
              onPressed: () {},
              child: Icon(started ? Icons.timer_outlined : Icons.close)),
        ),
      ),
    );
  }

  Widget buildItem(Modules item, BuildContext context) {
    return InkWell(
      key: Key(item.id.toString()),
      onTap: () {
        // Navigate to the details page. If the user leaves and returns to
        // the app after it has been killed while running in the
        // background, the navigation stack is restored.
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
}
