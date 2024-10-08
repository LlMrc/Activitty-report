import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/time_notifier.dart';
import '../../local/local.dart';
import '../../model/report.dart';
import '../../notifier/repport_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({super.key});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();
  late Repport _repport;

  @override
  void initState() {
    _repport = currentReport();
    super.initState();
  }

  Repport currentReport() {
    Repport? repport = _preference.getLastRepport();
    if (repport != null) {
      return repport;
    } else {
      return repport = Repport(
          name: '',
          student: 0,
          vizit: 0,
          publication: 0,
          isPyonye: true,
          submitAt: DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final myNotifier = Provider.of<RepportNotifier>(context);

    final boxShadow = BoxShadow(
        blurStyle: BlurStyle.inner,
        blurRadius: 5.0,
        color: color.shadow.withOpacity(0.2),
        offset: const Offset(2, 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromARGB(255, 129, 146, 99),
                boxShadow: [boxShadow]),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: const Color.fromARGB(255, 37, 138, 221),
                  ),
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromARGB(255, 121, 139, 89),
                ),
                child: buildTimer(context)),
          ),
        ),
        const SizedBox(height: 25),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.visit,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        counterButton(
                            color: color,
                            onPressed: () {
                              debugPrint('DECREMENT VIZIT');

                              myNotifier.decrementVizit(_repport);
                            },
                            icon: Icons.remove),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Consumer<RepportNotifier>(
                              builder: (context, notifier, _) {
                            int vizit = _repport.vizit ?? 0;
                            return Text('$vizit'.toUpperCase());
                          }),
                        ),
                        counterButton(
                            color: color,
                            onPressed: () {
                              debugPrint('INCREMENT VIZIT');
                              myNotifier.incrementVizit(_repport);
                            },
                            icon: Icons.add),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.publication, //'Piblikasyon',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    counterButton(
                        color: color,
                        onPressed: () {
                          myNotifier.decrementPublication(_repport);
                        },
                        icon: Icons.remove),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Consumer<RepportNotifier>(
                          builder: (context, _, child) {
                        //   int publication = _repport!.publication ?? 0;
                        return Text('${_repport.publication ?? 0}');
                      }),
                    ),
                    counterButton(
                        color: color,
                        onPressed: () {
                          myNotifier.incrementPublication(_repport);
                        },
                        icon: Icons.add),
                  ],
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget counterButton(
      {required ColorScheme color,
      required VoidCallback onPressed,
      required IconData icon}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.inner,
                  blurRadius: 5.0,
                  color: color.shadow.withOpacity(0.2),
                  offset: const Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(100)),
        child: Icon(icon),
      ),
    );
  }

  Widget boxShadowWidget({required Widget child}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(-4, -4),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: 0.95,
          heightFactor: 0.95,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimer(BuildContext context) {
    final myNotifier = context.watch<TimerNotifier>();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(myNotifier.duration.inHours);
    final minutes = twoDigits(myNotifier.duration.inMinutes.remainder(60));
    final seconds = twoDigits(myNotifier.duration.inSeconds.remainder(60));

    return Consumer<TimerNotifier>(builder: (context, timeNotifier, _) {
      return Text(
        '$hours:$minutes:$seconds',
        style: GoogleFonts.pressStart2p(),
      );
    });
  }
}
