import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class LinearTransitionExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel.builder(
      itemBuilder: (context, index) => TextItem(index),
      itemCount: 20,
      transitionBuilder: CarouselTransitions.linear,
    );
  }
}
