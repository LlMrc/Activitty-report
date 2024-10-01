import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/my_notifier.dart';

import '../local/local.dart';
import '../model/report.dart';

class RepportScreen extends StatefulWidget {
  const RepportScreen({super.key});

  static const routeName = '/repport_screen';

  @override
  _RepportScreenState createState() => _RepportScreenState();
}

class _RepportScreenState extends State<RepportScreen> {
  final SharedPreferencesSingleton _prefsInstance =
      SharedPreferencesSingleton();
  List<Repport> _repports = [];

  @override
  void initState() {
    _loadRepports();
    super.initState();
  }

  void _loadRepports() {
    setState(() {
      _repports = _prefsInstance.getAllRepports();
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  Future<void> _addRepport() async {
    var students = await _prefsInstance.getAllStudents();
    final newRepport = Repport(
      publication: null,
      time: null,
      vizit: null,
      name: nameController.text,
      student: students.length,
      comment: commentController.text,
      submitAt: DateTime.now(),
    );
    await _prefsInstance.saveRepport(newRepport);
    _loadRepports(); // Reload the list after adding
  }

  Future<void> _deleteRepport(Repport repport) async {
    await _prefsInstance.deleteRepportByMonthAndYear(repport.submitAt);
    _loadRepports(); // Reload the list after deleting
  }

  Future<void> _updateRepport(Repport repport) async {
    final updatedRepport = repport.copyWith(comment: 'Updated comment');
    await _prefsInstance.updateRepport(updatedRepport);
    _loadRepports(); // Reload the list after updating
  }

  @override
  Widget build(BuildContext context) {
    final isPyonye = Provider.of<PyonyeNotifier>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 12),
            headerWidget(),
            const SizedBox(height: 12),
            _repports.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      SvgPicture.asset(
                          height: 200, width: 100, 'assets/svg/no_repport.svg'),
                      const Text('Ou poko gen rapo')
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _repports.length,
                      itemBuilder: (context, index) {
                        final repport = _repports[index];
                        return Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                        'Rapo pou mwa ${DateFormat.yMMM().format(DateTime.now())}'),
                                    subtitle: Text(
                                        'Kantite etidyan: ${repport.student}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _updateRepport(repport),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.share,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          onPressed: () =>
                                              _deleteRepport(repport),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isPyonye.isPyonye == true)
                                    additionalDetail(repport),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Komante',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 50,
                                          child: Divider(
                                            color: Colors.grey,
                                          )),
                                    ],
                                  ),
                                  if (repport.comment != null ||
                                      repport.comment!.isNotEmpty)
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '${repport.comment}'),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                            Positioned(
                                top: -4,
                                right: 6,
                                child: removeRepport(
                                  onPressed: () => _deleteRepport(repport),
                                ))
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addRepport,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List Rapo',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Name lastName'),
              Text('Komanse ${DateFormat.yMMM().format(DateTime.now())}')
            ],
          ),
        ],
      ),
    );
  }

  Widget removeRepport({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Text(
          'x'.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget additionalDetail(Repport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Vizit: ${report.time}'),
            const SizedBox(width: 10),
            Text('piblikasyon: ${report.time}'),
          ],
        ),
        Text('time: ${report.time}'),
      ],
    );
  }
}
