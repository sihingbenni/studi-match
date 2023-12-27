import 'package:flutter/material.dart';

class PastelColorProvider {
  List<Color> pastelColors = [
    Colors.pink[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
    Colors.teal[100]!,
    Colors.red[100]!,
    Colors.cyan[100]!,
    Colors.amber[100]!,
    Colors.indigo[100]!,
    Colors.lime[100]!,
    Colors.greenAccent[100]!,
    Colors.orangeAccent[100]!,
    Colors.tealAccent[100]!,
    Colors.yellow[100]!,
    Colors.brown[100]!,
    Colors.lightGreen[100]!,
    Colors.deepPurple[100]!,
  ];

  Color generatePastelColor(index) => pastelColors[index % pastelColors.length];
}
