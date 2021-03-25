import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColorTransitionExample extends StatelessWidget {
  final Example example;

  ColorTransitionExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    final itemCount = 4;
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => Item(index),
          itemCount: itemCount,
          transitionBuilder: CarouselTransitions.color(colors: ColorItem.colors),
        ),
      ),
    );
  }
}
