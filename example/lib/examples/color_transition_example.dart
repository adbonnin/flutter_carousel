import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class ColorTransitionExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemCount = 4;
    return Carousel.builder(
      itemBuilder: (context, index) => Item(index),
      itemCount: itemCount,
      transitionBuilder: CarouselTransitions.color(
        colors: ColorItem.colors,
        singleColor: false
      ),
    );
  }
}
