import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/widgets.dart';

class LinearTransitionExample extends StatelessWidget {
  final Example example;

  LinearTransitionExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => ColorItem(index),
          itemCount: 20,
          transitionBuilder: CarouselTransitions.linear,
        ),
      ),
    );
  }
}
