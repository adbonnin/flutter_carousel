import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BuilderExample extends StatelessWidget {
  final Example example;

  BuilderExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => ColorItem(index),
          itemCount: 20,
        ),
      ),
    );
  }
}
