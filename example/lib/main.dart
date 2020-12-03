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
  Example('Basic example', Icons.eco, '/basic', (context) => BasicExample()),
  Example('Builder example', Icons.eco, '/builder', (context) => BuilderExample()),
  Example('Vertical example', Icons.eco, '/vertical', (context) => VerticalExample()),
  Example('Scale transition example', Icons.refresh, '/scale-transition', (context) => ScaleTransitionExample()),
  Example('Linear transition example', Icons.refresh, '/linear-transition', (context) => LinearTransitionExample()),
  Example('Cube transition example', Icons.refresh, '/cube-transition', (context) => CubeTransitionExample()),
  Example('Color transition example', Icons.refresh, '/color-transition', (context) => ColorTransitionExample()),
  Example('Compose transition example', Icons.refresh, '/compose-transition', (context) => ComposeTransitionExample()),
];

void main() => runApp(CarouselExample(examples));

class CarouselExample extends StatelessWidget {
  final List<Example> examples;

  CarouselExample(this.examples);

  @override
  Widget build(BuildContext context) {

    MapEntry<String, WidgetBuilder> entry(int index, Example example) {
      return MapEntry(
        example.route,
        (context) {
          return Scaffold(
            appBar: AppBar(title: Text(example.title)),
            body: Container(child: example.itemBuilder(context)),
          );
        },
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

  HomePage(this.examples);

  @override
  Widget build(BuildContext context) {
    ListTile listTile(Example example) {
      return ListTile(
        title: Row(
          children: [
            Icon(example.icon, color: Colors.black,),
            Container(width: 10,),
            Text(example.title),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, example.route),
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

class Example {
  final String title;
  final IconData icon;
  final String route;
  final WidgetBuilder itemBuilder;

  Example(this.title, this.icon, this.route, this.itemBuilder);
}
