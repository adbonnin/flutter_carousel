import 'package:example/example.dart';
import 'package:example/examples/basic_example.dart';
import 'package:example/examples/builder_example.dart';
import 'package:example/examples/color_transition_example.dart';
import 'package:example/examples/compose_transition_example.dart';
import 'package:example/examples/cube_transition_example.dart';
import 'package:example/examples/linear_transition_example.dart';
import 'package:example/examples/scale_transition_example.dart';
import 'package:example/examples/vertical_example.dart';
import 'package:flutter/material.dart';

final examples = [
  Example(
    title: 'Basic example',
    icon: Icons.eco,
    route: '/basic',
    itemBuilder: (context, example) => BasicExample(example),
  ),
  Example(
    title: 'Builder example',
    icon: Icons.eco,
    route: '/builder',
    itemBuilder: (context, example) => BuilderExample(example),
  ),
  Example(
    title: 'Vertical example',
    icon: Icons.eco,
    route: '/vertical',
    itemBuilder: (context, example) => VerticalExample(example),
  ),
  Example(
    title: 'Scale transition example',
    icon: Icons.refresh,
    route: '/scale-transition',
    itemBuilder: (context, example) => ScaleTransitionExample(example),
  ),
  Example(
    title: 'Linear transition example',
    icon: Icons.refresh,
    route: '/linear-transition',
    itemBuilder: (context, example) => LinearTransitionExample(example),
  ),
  Example(
    title: 'Cube transition example',
    icon: Icons.refresh,
    route: '/cube-transition',
    itemBuilder: (context, example) => CubeTransitionExample(example),
  ),
  Example(
    title: 'Color transition example',
    icon: Icons.refresh,
    route: '/color-transition',
    itemBuilder: (context, example) => ColorTransitionExample(example),
  ),
  Example(
    title: 'Compose transition example',
    icon: Icons.refresh,
    route: '/compose-transition',
    itemBuilder: (context, example) => ComposeTransitionExample(example),
  ),
];

void main() => runApp(CarouselExample(examples));

class CarouselExample extends StatelessWidget {
  final List<Example> examples;

  CarouselExample(
    this.examples, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapEntry<String, WidgetBuilder> entry(int index, Example example) {
      return MapEntry(
        example.route,
        (context) => example.itemBuilder(context, example),
      );
    }

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (ctx) => HomePage(examples),
        ...examples.asMap().map(entry),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Example> examples;

  HomePage(
    this.examples, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget listTile(Example example) {
      return Card(
        child: ListTile(
          leading: Icon(example.icon, color: Theme.of(context).primaryColor),
          title: Text(example.title),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, example.route),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Flutter Carousel Example')),
      body: ListView(
        children: examples.map(listTile).toList(),
      ),
    );
  }
}
