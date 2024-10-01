import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:report/src/feature/student/student_tile.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/timer.dart';
import 'package:report/src/notifier/time_notifier.dart';
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

  bool started = false;
  bool isPyonye = false;
  @override
  Widget build(BuildContext context) {
    final timeNotifier = Provider.of<TimerNotifier>(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        timeNotifier.saveTimer();
     
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
                                  child: SizedBox(
                                    width: 200,
                                    child: isPyonye
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 2,
                                                    ),
                                              ),
                                            ],
                                          )
                                        : const StopwatchWidget(),
                                  ),
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
            Consumer<TimerNotifier>(builder: (context, timer, child) {
          return FloatingActionButton(
              onPressed: () {
                timer.toggleStarted();
                timer.isStarted ? timer.stopTimer() : timer.startTimer();
              },
              child: timer.isStarted
                  ? const Icon(Icons.timer_outlined)
                  : const Icon(Icons.timer_off_outlined));
        }),
        bottomNavigationBar: AnimatedOpacity(
          duration: Durations.medium1,
          opacity: 1,
          child: Consumer<TimerNotifier>(builder: (context, notifier, _) {
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          content: const Text('kontè a rekòmanse a zero!')));
                    },
                  ),
                  BottomAppBarIcon(
                    icon: Icons.save,
                    label: 'Save',
                    onPressed: () {
                      notifier.saveTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ou anrejistre lè a!')));
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  deleteDialog(BuildContext context) {
    return AlertDialog.adaptive(
      iconColor: Theme.of(context).colorScheme.error,
      icon: const Icon(Icons.question_mark),
      content: Text('Ou vle anile sevis pyonye a ?'.toUpperCase()),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Non',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            )),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Wi',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            )),
      ],
    );
  }
}
