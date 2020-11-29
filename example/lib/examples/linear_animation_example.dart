import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class LinearAnimationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel.builder(
      itemBuilder: (context, index) => TextItem(index),
      itemCount: 20,
      itemAnimationBuilder: CarouselAnimations.linear,
    );
  }
}
