import 'package:flutter/widgets.dart';

typedef CarouselItemAnimationBuilder = Widget Function(BuildContext context, int index, Widget child, int page, double distanceFromCurrentPage);

class CarouselAnimations {
  static CarouselItemAnimationBuilder scale(ratio) {
    return (BuildContext context, int index, Widget child, int page, double distanceFromCurrentPage) {
      var distortion = (1 - distanceFromCurrentPage.abs() * ratio).clamp(0.0, 1.0);
      return Transform.scale(
        scale: Curves.easeOut.transform(distortion),
        child: child,
      );
    };
  }

  static CarouselItemAnimationBuilder linear = (BuildContext context, int index, Widget child, int page, double distanceFromCurrentPage) {
    return child;
  };
}
