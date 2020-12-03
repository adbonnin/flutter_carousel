import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class BasicExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Carousel(
        children: [
          ColorItem(0),
          ColorItem(1),
          ColorItem(2),
          ColorItem(3),
        ],
      ),
    );
  }
}
