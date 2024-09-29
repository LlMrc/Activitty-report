import 'package:flutter/material.dart';

import '../../../model/event.dart';

class StickyNoteCalendar extends StatelessWidget {
  const StickyNoteCalendar({super.key, required this.event});
final Event event;
  @override
  Widget build(BuildContext context) {
  
    return Container(
      constraints: const BoxConstraints(minHeight: 150, maxWidth: 300),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 241, 184),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          width: double.maxFinite,
          color: const Color.fromARGB(255, 234, 235, 176),
          child: Text(event.title  ?? 'Okenn tit'.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(event.comment ?? 'Okenn deskripsyon',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
  }
