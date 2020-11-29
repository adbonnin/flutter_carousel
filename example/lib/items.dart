import 'package:flutter/material.dart';

class TextItem extends StatelessWidget {
  final int index;

  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
  ];

  TextItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: colors[index % colors.length]),
      child: Center(
        child: Text(
          'Item: $index',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
