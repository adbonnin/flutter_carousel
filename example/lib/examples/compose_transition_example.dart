import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/widgets.dart';

class ComposeTransitionExample extends StatelessWidget {
  final Example example;

  ComposeTransitionExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => Item(index),
          itemCount: 20,
          transitionBuilder: CarouselTransitions.compose([
            CarouselTransitions.color(
              colors: ColorItem.colors,
              singleColor: false,
            ),
            CarouselTransitions.fade(fade: 1),
            CarouselTransitions.scale(scale: 1),
            CarouselTransitions.cube,
          ]),
        ),
      ),
    );
  }
}
