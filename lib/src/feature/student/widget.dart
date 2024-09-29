import 'package:flutter/material.dart';

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
