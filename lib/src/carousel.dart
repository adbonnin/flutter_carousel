import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/src/carousel_transition.dart';

const Axis _defaultScrollDirection = Axis.horizontal;

const bool _defaultReverse = false;

const bool _defaultPageSnapping = true;

final CarouselTransitionBuilder _defaultTransitionBuilder = CarouselTransitions.scale();

class Carousel extends StatefulWidget {

  final Key key;

  final Axis scrollDirection;

  final bool reverse;

  final CarouselController controller;

  final ScrollPhysics physics;

  final bool pageSnapping;

  final ValueChanged<int> onPageChanged;

  final ValueChanged<int> onIndexChanged;

  final CarouselChildDelegate childrenDelegate;

  final CarouselTransitionBuilder transitionBuilder;

  Carousel({
    this.key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    List<Widget> children = const <Widget>[],
    CarouselTransitionBuilder transitionBuilder,
  })  : childrenDelegate = new CarouselChildListDelegate(children),
        transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        super(key: key);

  Carousel.builder({
    this.key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    CarouselTransitionBuilder transitionBuilder,
  })  : transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        childrenDelegate = new CarouselChildBuildDelegate(itemBuilder, itemCount),
        super(key: key);

  Carousel.custom({
    this.key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    @required this.childrenDelegate,
    CarouselTransitionBuilder transitionBuilder,
  })  : transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        assert(childrenDelegate != null),
        super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class CarouselController {

  final int itemCount;

  final int pageOffset;

  final PageController pageController;

  CarouselController({
    @required this.itemCount,
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 0.8,
    this.pageOffset = 100000,
  }) : assert(itemCount != null),
       pageController = PageController(
          initialPage: pageOffset + initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  double get currentPage {

    if (pageController.position.haveDimensions) {
      return pageController.page;
    }

    var storageContext = pageController.position.context.storageContext;
    var pageStored = PageStorage.of(storageContext)?.readState(storageContext) as double;
    if (pageStored != null) {
      return pageStored;
    }

    return pageController.initialPage.toDouble();
  }

  int pageToIndex(int page) {
    return itemCount <= 0 ? -1 : (page - pageOffset) % itemCount;
  }

  int indexToPage(int index) {

    if (itemCount <= 0) {
      return -1;
    }

    final int currentPage = this.currentPage.round();
    final int currentIndex = pageToIndex(currentPage);
    return currentPage - currentIndex + index;
  }

  void jumpToPage(int page) {
    return pageController.jumpToPage(page);
  }

  void jumToIndex(int index) {
    return jumpToPage(pageOffset + index);
  }

  Future<void> nextPage({@required Duration duration, @required Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  Future<void> previousPage({@required Duration duration, @required Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  Future<void> animateToPage(int page, {@required Duration duration, @required Curve curve}) {
    return pageController.animateToPage(page, duration: duration, curve: curve);
  }

  Future<void> animateToIndex(int index, {@required Duration duration, @required Curve curve}) {
    final page = indexToPage(index);
    return pageController.animateToPage(page, duration: duration, curve: curve);
  }

  @mustCallSuper
  void dispose() {
    pageController.dispose();
  }
}

class _CarouselState extends State<Carousel> {

  CarouselController _controller;

  CarouselController get _effectiveController => widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = CarouselController(itemCount: widget.childrenDelegate.itemCount);
    }
  }

  @override
  void didUpdateWidget(Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null && widget.controller == null) {
        _controller = CarouselController(itemCount: widget.childrenDelegate.itemCount);
      }
      else if (oldWidget.controller == null && widget.controller != null) {
        _controller.dispose();
        _controller = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: _effectiveController.pageController,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: (page) {
        if (widget.onPageChanged != null) {
          widget.onPageChanged(page);
        }
        if (widget.onIndexChanged != null) {
          widget.onIndexChanged(widget.controller.pageToIndex(page));
        }
      },
      itemBuilder: (context, index) => _buildAnimatedPage(context, index),
    );
  }

  Widget _buildAnimatedPage(BuildContext context, int page) {
    var index = _effectiveController.pageToIndex(page);
    if (index < 0) {
      return null;
    }

    return AnimatedBuilder(
      animation: _effectiveController.pageController,
      builder: (context, child) {
        return widget.transitionBuilder(context, index, child, page, _effectiveController.currentPage);
      },
      child: widget.childrenDelegate.build(context, index),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}

abstract class CarouselChildDelegate {

  const CarouselChildDelegate();

  int get itemCount => -1;

  Widget build(BuildContext context, int index);
}

class CarouselChildListDelegate implements CarouselChildDelegate {

  final List<Widget> children;

  const CarouselChildListDelegate(this.children) : assert(children != null);

  @override
  int get itemCount {
    return children.length;
  }

  @override
  Widget build(BuildContext context, int index) {
    return children[index];
  }
}

class CarouselChildBuildDelegate implements CarouselChildDelegate {

  final IndexedWidgetBuilder builder;

  final int itemCount;

  const CarouselChildBuildDelegate(this.builder, this.itemCount)
      : assert(builder != null),
        assert(itemCount != null);

  @override
  Widget build(BuildContext context, int index) {
    return builder(context, index);
  }
}
