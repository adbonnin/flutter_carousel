import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/widgets.dart';

class CubeTransitionExample extends StatelessWidget {
  final Example example;

  CubeTransitionExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    final itemCount = 20;
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => ColorItem(index),
          controller: CarouselController(itemCount: itemCount, viewportFraction: 1),
          itemCount: itemCount,
          transitionBuilder: CarouselTransitions.cube,
          pageSnapping: true,
        ),
      ),
    );
  }
}
