import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';

typedef CarouselTransitionBuilder = Widget Function(
  BuildContext context,
  int index,
  Widget child,
  int page,
  double currentPage,
);

class CarouselTransitions {
  static CarouselTransitionBuilder scale(ratio) {
    return (
      BuildContext context,
      int index,
      Widget child,
      int page,
      double currentPage,
    ) {
      final distance = page - currentPage;
      if (distance == 0.0) {
        return child;
      }

      final distortion = (1 - distance.abs() * ratio).clamp(0.0, 1.0);
      return Transform.scale(
        scale: Curves.easeOut.transform(distortion),
        child: child,
      );
    };
  }

  static CarouselTransitionBuilder linear = (
    BuildContext context,
    int index,
    Widget child,
    int page,
    double currentPage,
  ) {
    return child;
  };

  static CarouselTransitionBuilder cube = (
    BuildContext context,
    int index,
    Widget child,
    int page,
    double currentPage,
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