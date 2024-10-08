import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report/src/model/student.dart';
import 'package:report/src/notifier/counter_state.dart';

class MyCounter extends StatelessWidget {
  const MyCounter({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    final pyonyeNotifier = Provider.of<PyonyeNotifier>(context);
    return Row(
      children: [
        IconButton.filled(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).cardColor)),
          iconSize: 14,
          icon: const Icon(
            Icons.remove,
            color: Colors.black,
          ),
          onPressed: () {
            pyonyeNotifier.decrement(student);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('${pyonyeNotifier.count}'.toUpperCase()),
        ),
        IconButton.filled(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).cardColor)),
          iconSize: 14,
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () {
            pyonyeNotifier.increment(student);
          },
        )
      ],
    );
  }
}
