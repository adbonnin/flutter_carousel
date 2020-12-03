import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

typedef CarouselTransitionBuilder = Widget Function(
  BuildContext context,
  Widget child,
  int page,
  double currentPage,
  int index,
  double currentIndex,
  int itemCount,
);

class CarouselTransitions {
  static CarouselTransitionBuilder compose(List<CarouselTransitionBuilder> transitions) {
    return (
      BuildContext context,
      Widget child,
      int page,
      double currentPage,
      int index,
      double currentIndex,
      int itemCount,
    ) {
      var currentChild = child;

      for (CarouselTransitionBuilder transition in transitions) {
        currentChild = transition(
          context,
          currentChild,
          page,
          currentPage,
          index,
          currentIndex,
          itemCount,
        );
      }

      return currentChild;
    };
  }

  static CarouselTransitionBuilder fade({
    double fade = 0.5,
    Curve curve = Curves.easeOut,
  }) {
    return (
      BuildContext context,
      Widget child,
      int page,
      double currentPage,
      int index,
      double currentIndex,
      int itemCount,
    ) {
      final distance = page - currentPage;
      if (distance == 0.0) {
        return child;
      }

      final pageFade = (1 - distance.abs() * fade).clamp(0.0, 1.0);
      return Opacity(
        opacity: curve.transform(pageFade),
        child: child,
      );
    };
  }

  static CarouselTransitionBuilder color({
    @required List<Color> colors,
    bool singleColor = true,
  }) {
    return (
      BuildContext context,
      Widget child,
      int page,
      double currentPage,
      int index,
      double currentIndex,
      int itemCount,
    ) {
      assert(colors != null && colors.length > 0);
      assert(itemCount != null);

      final sequence = TweenSequence(colors
          .asMap()
          .entries
          .map((e) => TweenSequenceItem(
                weight: 1,
                tween: ColorTween(
                  begin: e.value,
                  end: colors[(e.key + 1) % colors.length],
                ),
              ))
          .toList());

      return DecoratedBox(
        decoration: BoxDecoration(
          color: sequence.evaluate(AlwaysStoppedAnimation((singleColor ? currentIndex : index) / itemCount)),
        ),
        child: child,
      );
    };
  }

  static CarouselTransitionBuilder scale({
    double scale = 0.3,
    Curve curve = Curves.easeOut,
  }) {
    return (
      BuildContext context,
      Widget child,
      int page,
      double currentPage,
      int index,
      double currentIndex,
      int itemCount,
    ) {
      final distance = page - currentPage;
      if (distance == 0.0) {
        return child;
      }

      final pageScale = (1 - distance.abs() * scale).clamp(0.0, 1.0);
      return Transform.scale(
        scale: curve.transform(pageScale),
        child: child,
      );
    };
  }

  static CarouselTransitionBuilder linear = (
    BuildContext context,
    Widget child,
    int page,
    double currentPage,
    int index,
    double currentIndex,
    int itemCount,
  ) {
    return child;
  };

  static CarouselTransitionBuilder cube = (
    BuildContext context,
    Widget child,
    int page,
    double currentPage,
    int index,
    double currentIndex,
    int itemCount,
  ) {
    final distance = page - currentPage;
    if (distance == 0.0) {
      return child;
    }
    else if (distance > 1 || distance < -1) {
      return Container();
    }

    final previous = distance <= 0;
    final rotationY = lerpDouble(0, 90, distance);

    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(-1 * rotationY * (pi / 180.0));

    return Transform(
      alignment: previous ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: child,
    );
  };
}
