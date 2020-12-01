import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class ScaleTransitionExample extends StatefulWidget {
  @override
  State createState() => new _ScaleTransitionExampleState();
}

class _ScaleTransitionExampleState extends State<ScaleTransitionExample> {
  double _viewportFraction = 0.8;
  double _scale = 0.3;
  double _fade = 0.5;
  final int itemCount = 20;

  @override
  Widget build(BuildContext context) {
    final carouselController = new CarouselController(
      viewportFraction: _viewportFraction,
      itemCount: itemCount,
    );

    const labelStyle = TextStyle(fontSize: 20);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Carousel.builder(
          controller: carouselController,
          itemBuilder: (context, index) => TextItem(index),
          itemCount: itemCount,
          transitionBuilder: CarouselTransitions.scale(scale: _scale, fade: _fade),
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
                TableCell(child: Text("Fade:", style: labelStyle)),
                TableCell(
                  child: Slider.adaptive(
                    min: 0,
                    max: 1,
                    value: _fade,
                    onChanged: (double value) {
                      setState(() => _fade = value);
                    },
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
