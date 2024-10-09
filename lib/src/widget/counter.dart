import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report/src/notifier/my_notifier.dart';

import '../model/student.dart';

class MyCounter extends StatelessWidget {
  const MyCounter({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    final pyonyeNotifier = Provider.of<PyonyeNotifier>(context);
    return Row(
      children: [
        counterButton(
          context,
          icon: Icons.remove,
          onPressed: () {
            pyonyeNotifier.decrement(student);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // Using Consumer to listen to PyonyeNotifier and update UI when lesson count changes
          child: Consumer<PyonyeNotifier>(
            builder: (context, pyonyeNotifier, child) {
              return Text('${student.lesson ?? 0}'.toUpperCase());
            },
          ),
        ),
        counterButton(
          context,
          icon: Icons.add,
          onPressed: () {
            pyonyeNotifier.increment(student);
          },
        )
      ],
    );
  }

  Widget counterButton(BuildContext context,
      {required onPressed, required IconData icon}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0.5, -0.5), blurRadius: 1, color: Colors.grey),
              BoxShadow(
                  offset: Offset(0.5, 0.5), blurRadius: 1, color: Colors.grey)
            ],
            borderRadius: BorderRadius.circular(100)),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
