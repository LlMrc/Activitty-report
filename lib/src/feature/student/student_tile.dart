import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/student.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../notifier/my_notifier.dart';
import '../../widget/counter.dart';
import 'widget.dart';

class StudentListTile extends StatefulWidget {
  const StudentListTile({super.key});

  @override
  State<StudentListTile> createState() => _StudentListTileState();
}

class _StudentListTileState extends State<StudentListTile> {
  var commentController = TextEditingController();
  final SharedPreferencesSingleton _preference = SharedPreferencesSingleton();

  @override
  Widget build(BuildContext context) {
    final myNotifier = context.watch<PyonyeNotifier>();

    return FutureBuilder<List<Student>>(
      future: SharedPreferencesSingleton().getAllStudents(),
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Wrap the CircularProgressIndicator in a SliverToBoxAdapter
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (data == null || data.isEmpty) {
          // Wrap the emptyStudentList widget in a SliverToBoxAdapter
          return SliverToBoxAdapter(
            child: emptyStudentList(),
          );
        }
        // Initialize expansion states with the correct number of students
        myNotifier.initializeExpansionStates(data.length);
        // SliverList for displaying students
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final student = data[index];

              // Ensure that the expansion states are initialized with the correct item count
              myNotifier.initializeExpansionStates(data.length);

              return Dismissible(
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Theme.of(context).colorScheme.error,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      Icon(Icons.delete_forever, color: Colors.white),
                    ],
                  ),
                ),
                key: Key(student.name),
                onDismissed: (direction) {
                  _preference.removeStudent(student);
                  _preference.removeStudent(student);
                  // Optionally, reinitialize _expansionStates after removal
                  myNotifier.initializeExpansionStates(data.length - 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: ExpansionTile(
                      initiallyExpanded: myNotifier.isExpand(index),
                      key: UniqueKey(),
                      dense: true,
                      leading: GestureDetector(
                          onTap: () {
                            _makePhoneCall(student.phoneNumber);
                          },
                          child: const CircleAvatar(child: Icon(Icons.call))),
                      title: Text(student.name.toUpperCase()),
                      subtitle: (student.schedule != null)
                          ? Text(
                              student.schedule!,
                              overflow: TextOverflow.clip,
                            )
                          : null,
                      children: [studentDetails(student, context)],
                      onExpansionChanged: (value) {
                        myNotifier.toggleExpansion(value, index);
                      },
                    ),
                  ),
                ),
              );
            },
            childCount: data.length,
          ),
        );
      },
    );
  }

  Widget studentDetails(Student updatedStudent, context) {
    final Uri url = Uri.parse(AppLocalizations.of(context)!.url);
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _launchInBrowser(url);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 120,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/viv.png'))),
                  ),
                ),
                Text(
                  DateFormat.yMMMMd().format(updatedStudent.dateAdded),
                  style: const TextStyle(fontSize: 10),
                )
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.lesson,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 20),
                      MyCounter(student: updatedStudent),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              addOrUpdateComment(updatedStudent));
                    },
                    child: Container(
                        constraints: const BoxConstraints(minWidth: 200),
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        child: Text(
                          '${updatedStudent.comment}',
                          style: TextStyle(color: Colors.grey.shade700),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null) return;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  addOrUpdateComment(Student updatedStudent) {
    return AlertDialog.adaptive(
      content: TextField(
        controller: commentController,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: '${updatedStudent.comment}'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              _preference.updateStudentComment(
                  updatedStudent, commentController.text);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text(AppLocalizations.of(context)!.add))
      ],
    );
  }
}
