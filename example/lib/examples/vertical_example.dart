import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/example.dart';
import 'package:example/item.dart';
import 'package:flutter/widgets.dart';

class VerticalExample extends StatelessWidget {
  final Example example;

  VerticalExample(
    this.example,
  );

  @override
  Widget build(BuildContext context) {
    return ExampleView(
      example,
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Carousel.builder(
          itemBuilder: (context, index) => ColorItem(index),
          itemCount: 20,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
