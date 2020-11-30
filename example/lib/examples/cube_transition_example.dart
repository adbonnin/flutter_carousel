import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class CubeTransitionExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemCount = 20;
    return Carousel.builder(
      itemBuilder: (context, index) => TextItem(index),
      controller: CarouselController(itemCount: itemCount, viewportFraction: 1),
      itemCount: itemCount,
      transitionBuilder: CarouselTransitions.cube,
      pageSnapping: true,
    );
  }
}
