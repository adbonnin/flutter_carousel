import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Example {
  final String title;
  final IconData icon;
  final String route;
  final ExampleWidgetBuilder itemBuilder;

  Example({
    required this.title,
    required this.icon,
    required this.route,
    required this.itemBuilder,
  });
}

typedef ExampleWidgetBuilder = Widget Function(BuildContext context, Example example);

class ExampleView extends StatelessWidget {
  ExampleView(
    this.example, {
    required this.body,
    this.options,
  });

  final Example example;
  final Widget body;
  final Widget? options;

  @override
  Widget build(BuildContext context) {
    final Widget effectiveBody;
    final Widget? effectiveBottomBar;

    if (MediaQuery.of(context).size.width < 1199) {
      effectiveBody = body;
      effectiveBottomBar = options == null
          ? null
          : Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: options,
            );
    }
    else {
      final List<Widget> children = [Expanded(child: body)];

      if (options != null) {
        children.add(
          Container(
            width: 400,
            child: Drawer(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: options,
              ),
            ),
          ),
        );
      }

      effectiveBody = Row(children: children);
      effectiveBottomBar = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(example.title)),
      body: effectiveBody,
      bottomNavigationBar: effectiveBottomBar,
    );
  }
}
