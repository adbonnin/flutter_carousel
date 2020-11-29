import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class VerticalExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Carousel.builder(
        itemBuilder: (context, index) => TextItem(index),
        itemCount: 20,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
