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

  Widget label(String message) {
    return TableCell(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          message,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carouselController = new CarouselController(
      viewportFraction: _viewportFraction,
      itemCount: itemCount,
      infiniteScroll: _infiniteScroll,
      initialIndex: _currentIndex,
      keepPage: false,
    );

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
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
        ),
        Container(
          width: 400,
          child: Drawer(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Table(
                columnWidths: {0: IntrinsicColumnWidth()},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      label("Viewport Fraction"),
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
                      label("Scale"),
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
                      label("Infinite Scroll"),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
