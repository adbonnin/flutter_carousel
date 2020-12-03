import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final int index;

  Item(this.index);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Item: $index',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}

class ColorItem extends StatelessWidget {

  static const List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
  ];

  final int index;

  ColorItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: colors[index % colors.length]),
      child: Item(index),
    );
  }
}
