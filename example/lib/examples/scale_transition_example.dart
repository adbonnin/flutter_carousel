import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class ScaleTransitionExample extends StatefulWidget {
  @override
  State createState() => new _ScaleTransitionExampleState();
}

class _ScaleTransitionExampleState extends State<ScaleTransitionExample> {
  PageStorageKey _key = PageStorageKey(0);
  double _viewportFraction = 0.8;
  double _scale = 0.3;
  bool _infiniteScroll = true;
  int _currentIndex = 0;

  final int itemCount = 20;

  @override
  Widget build(BuildContext context) {
    final carouselController = new CarouselController(
      viewportFraction: _viewportFraction,
      itemCount: itemCount,
      infiniteScroll: _infiniteScroll,
      initialIndex: _currentIndex,
      keepPage: false,
    );

    const labelStyle = TextStyle(fontSize: 20);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Carousel.builder(
          key: _key,
          controller: carouselController,
          itemBuilder: (context, index) => ColorItem(index),
          itemCount: itemCount,
          transitionBuilder: CarouselTransitions.scale(scale: _scale),
          onIndexChanged: (int value) {
            setState(() => _currentIndex = value);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Table(
          columnWidths: {0: IntrinsicColumnWidth()},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(child: Text("Viewport Fraction:", style: labelStyle)),
                TableCell(
                  child: Slider.adaptive(
                    min: 0.5,
                    max: 1,
                    value: _viewportFraction,
                    onChanged: (double value) {
                      setState(() => _viewportFraction = value);
                    },
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Scale:", style: labelStyle)),
                TableCell(
                  child: Slider.adaptive(
                    min: 0,
                    max: 1,
                    value: _scale,
                    onChanged: (double value) {
                      setState(() => _scale = value);
                    },
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Infinite Scroll:", style: labelStyle)),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Checkbox(
                      value: _infiniteScroll,
                      onChanged: (bool? value) {
                        setState(() {
                          _infiniteScroll = value ?? false;
                          _key = PageStorageKey(DateTime.now().millisecondsSinceEpoch);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
