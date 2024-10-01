import 'package:flutter/material.dart';

class BottomAppBarIcon extends StatelessWidget {
  const BottomAppBarIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.green,
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 60,
      
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon),
            Positioned(
              bottom: -4, // Adjust the value as needed to move text closer
              child: Text(label, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
            ),
          ],
        ),
      ),
    );
  }
}
