import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/adbonnin_flutter_carousel.dart';
import 'package:example/items.dart';

class ScaleAnimationExample extends StatefulWidget {
  @override
  State createState() => new _ScaleAnimationExampleState();
}

class _ScaleAnimationExampleState extends State<ScaleAnimationExample> {
  double _viewportFraction = 0.8;
  double _ratio = 0.3;

  @override
  Widget build(BuildContext context) {
    final carouselController = new CarouselController(viewportFraction: _viewportFraction);
    const labelStyle = TextStyle(fontSize: 20);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10),
        child: Carousel.builder(
          controller: carouselController,
          itemBuilder: (context, index) => TextItem(index),
          itemCount: 20,
          itemAnimationBuilder: CarouselAnimations.scale(_ratio),
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
                TableCell(child: Text("Ratio:", style: labelStyle)),
                TableCell(
                  child: Slider.adaptive(
                    min: 0,
                    max: 1,
                    value: _ratio,
                    onChanged: (double value) {
                      setState(() => _ratio = value);
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