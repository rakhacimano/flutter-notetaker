import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/models/notetaker.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightBlue.shade300,
  Colors.lightGreen.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
];

class NotatakerCardWidget extends StatelessWidget {
  const NotatakerCardWidget(
      {super.key, required this.notetaker, required this.index});
  final Notetaker notetaker;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time =
        DateFormat().add_yMMMd().add_jms().format(notetaker.createdTime);
    final minHeight = _getMinHeight(index);
    final color = _lightColors[index % _lightColors.length];

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade900),
            ),
            const SizedBox(height: 4),
            Text(notetaker.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20)),
          ],
        ),
      ),
    );
  }

  double _getMinHeight(int index) {
    switch (index % 4) {
      case 0:
      case 3:
        return 100;
      case 1:
      case 2:
        return 150;
      default:
        return 100;
    }
  }
}
