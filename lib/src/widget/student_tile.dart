import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:report/src/local/local.dart';
import 'package:report/src/model/student.dart';
import 'package:url_launcher/url_launcher.dart';

import 'counter.dart';

class StudentListTile extends StatelessWidget {
  const StudentListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferencesSingleton().getAllStudents(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          if (data == null || data.isEmpty) {
            return emptyStudentList();
          }
          return Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (cntext, index) {
                  final student = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ExpansionTile(
                        dense: true,
                        leading: GestureDetector(
                            onTap: () {
                              _makePhoneCall(student.phoneNumber);
                            },
                            child: const CircleAvatar(
                              child: Icon(Icons.call),
                            )),
                        title: Text(student.name.toUpperCase()),
                        subtitle: Text(student.address ?? '', overflow: TextOverflow.clip,),
                        children: [studentDetails(student, context)],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null) return;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget studentDetails(Student student, context) {
    debugPrint('STUDENT COMMENT: ${student.comment}');

    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top:8),
                height: 120,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/viv.png'))),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('Leson:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(width: 20),
                      MyCounter(),
                    ],
                  ),
                  GestureDetector(
                    onLongPress: (){
                    
                    },
                    child: Container(
                        constraints: const BoxConstraints(minWidth: 200),
                        height: 60,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        child: Text('${student.comment}')),
                  ),
                  Text(
                    DateFormat.yMMMMd().format(student.dateAdded),
                    style: const TextStyle(fontSize: 8),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget emptyStudentList() {
  return SizedBox(
      child: Column(
          children: List.generate(
              3,
              (index) => ListTile(
                    leading: const CircleAvatar(),
                    title: Container(
                        width: 70, height: 18, color: Colors.grey[300]),
                    subtitle: Container(
                        width: 50, height: 20, color: Colors.grey[200]),
                  ))));
}
