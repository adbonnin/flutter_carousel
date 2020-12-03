import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class ComposeTransitionExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
