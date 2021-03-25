import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BasicExample extends StatelessWidget {
  final Example example;

  BasicExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Carousel(
          children: [
            ColorItem(0),
            ColorItem(1),
            ColorItem(2),
            ColorItem(3),
          ],
        ),
      ),
    );
  }
}
