import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/src/carousel_animation.dart';

const Axis _defaultScrollDirection = Axis.horizontal;

final CarouselItemAnimationBuilder _defaultCarouselItemAnimationBuilder = CarouselAnimations.scale(0.3);

class Carousel extends StatefulWidget {

  final CarouselController controller;

  final CarouselChildDelegate childrenDelegate;

  final CarouselItemAnimationBuilder itemAnimationBuilder;

  final Axis scrollDirection;

  final ValueChanged<int> onPageChanged;

  final ValueChanged<int> onIndexChanged;

  Carousel({
    Key key,
    this.controller,
    List<Widget> children = const <Widget>[],
    CarouselItemAnimationBuilder itemAnimationBuilder,
    this.scrollDirection = _defaultScrollDirection,
    this.onPageChanged,
    this.onIndexChanged,
  }) : itemAnimationBuilder = itemAnimationBuilder ?? _defaultCarouselItemAnimationBuilder,
       childrenDelegate = new CarouselChildListDelegate(children),
       super(key: key);

  Carousel.builder({
    Key key,
    this.controller,
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    CarouselItemAnimationBuilder itemAnimationBuilder,
    this.scrollDirection = _defaultScrollDirection,
    this.onPageChanged,
    this.onIndexChanged,
  }) : itemAnimationBuilder = itemAnimationBuilder ?? _defaultCarouselItemAnimationBuilder,
       childrenDelegate = new CarouselChildBuildDelegate(itemBuilder, itemCount),
       super(key: key);

  Carousel.custom({
    Key key,
    this.controller,
    @required this.childrenDelegate,
    CarouselItemAnimationBuilder itemAnimationBuilder,
    this.scrollDirection = _defaultScrollDirection,
    this.onPageChanged,
    this.onIndexChanged,
  }) : itemAnimationBuilder = itemAnimationBuilder ?? _defaultCarouselItemAnimationBuilder,
       assert(childrenDelegate != null),
       super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class CarouselController {

  final int pageOffset;

  final PageController pageController;

  CarouselController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 0.8,
    this.pageOffset = 100000,
  }) : pageController = PageController(
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

  int pageToIndex(int page, int childCount) {
    return childCount <= 0 ? -1 : (page - pageOffset) % childCount;
  }

  int indexToPage(int index, int childCount) {

    if (childCount <= 0) {
      return -1;
    }

    final int currentPage = this.currentPage.round();
    final int currentIndex = pageToIndex(currentPage, childCount);
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

  Future<void> animateToIndex(int index, int childCount, {@required Duration duration, @required Curve curve}) {
    final page = indexToPage(index, childCount);
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
      _controller = CarouselController();
    }
  }

  @override
  void didUpdateWidget(Carousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null && widget.controller == null) {
        _controller = CarouselController();
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
      controller: _effectiveController.pageController,
      itemBuilder: (context, index) => _buildAnimatedPage(context, index),
      scrollDirection: widget.scrollDirection,
      onPageChanged: (page) {
        if (widget.onPageChanged != null) {
          widget.onPageChanged(page);
        }
        if (widget.onIndexChanged != null) {
          widget.onIndexChanged(widget.controller.pageToIndex(page, widget.childrenDelegate.childCount));
        }
      },
    );
  }

  Widget _buildAnimatedPage(BuildContext context, int page) {

    var index = _effectiveController.pageToIndex(page, widget.childrenDelegate.childCount);
    if (index < 0) {
      return null;
    }

    return AnimatedBuilder(
      animation: _effectiveController.pageController,
      builder: (context, child) {
        var distanceFromCurrentPage = page - _effectiveController.currentPage;
        return widget.itemAnimationBuilder(context, index, child, page, distanceFromCurrentPage);
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

  int get childCount => -1;

  Widget build(BuildContext context, int index);
}

class CarouselChildListDelegate implements CarouselChildDelegate {

  final List<Widget> children;

  const CarouselChildListDelegate(
      this.children
  ) : assert(children != null);

  @override
  int get childCount {
    return children.length;
  }

  @override
  Widget build(BuildContext context, int index) {
    return children[index];
  }
}

class CarouselChildBuildDelegate implements CarouselChildDelegate {

  final IndexedWidgetBuilder builder;

  final int childCount;

  const CarouselChildBuildDelegate(
      this.builder,
      this.childCount
      ) : assert(builder != null),
          assert(childCount != null);

  @override
  Widget build(BuildContext context, int index) {
    return builder(context, index);
  }
}