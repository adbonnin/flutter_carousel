# adbonnin_flutter_carousel

A carousel widget for Flutter.

## Features

* Infinite scroll
* Horizontal or vertical scrolling
* Customizable transition
* Dart null safety enable

## Supported platforms

* Flutter Android
* Flutter iOS
* Flutter web
* Flutter desktop

## Live preview

https://adbonnin.github.io/flutter_carousel

Basic carousel example:

![simple](https://raw.githubusercontent.com/adbonnin/flutter_carousel/main/doc/screenshots/basic.gif)

## How to use

Create a `Carousel` widget with some `children` :

```dart
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
```
