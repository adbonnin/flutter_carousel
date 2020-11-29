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
          TextItem(0),
          TextItem(1),
          TextItem(2),
          TextItem(3),
        ],
      ),
    );
  }
}
