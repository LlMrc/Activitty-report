import 'package:flutter/material.dart';

class MyCounter extends StatelessWidget {
  const MyCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
                    style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).cardColor)),

          iconSize: 14,
          icon: const Icon(Icons.remove,  color: Colors.black,
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('0'.toUpperCase()),
        ),
        IconButton.filled(
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor)),
          iconSize: 14,
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () {},
        )
      ],
    );
  }
}
