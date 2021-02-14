import 'package:flutter/widgets.dart';
import 'package:adbonnin_flutter_carousel/src/carousel_transition.dart';

const Axis _defaultScrollDirection = Axis.horizontal;

const bool _defaultReverse = false;

const bool _defaultInfiniteScroll = true;

const int _defaultPageOffset = 10000;

const bool _defaultPageSnapping = true;

final CarouselTransitionBuilder _defaultTransitionBuilder = CarouselTransitions.scale();

class Carousel extends StatefulWidget {

  final Axis scrollDirection;

  final bool reverse;

  final CarouselController? controller;

  final ScrollPhysics? physics;

  final bool pageSnapping;

  final ValueChanged<int>? onPageChanged;

  final ValueChanged<int>? onIndexChanged;

  final CarouselChildDelegate childrenDelegate;

  final CarouselTransitionBuilder transitionBuilder;

  Carousel({
    Key? key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    List<Widget> children = const <Widget>[],
    CarouselTransitionBuilder? transitionBuilder,
  })  : childrenDelegate = new CarouselChildListDelegate(children),
        transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        super(key: key);

  Carousel.builder({
    Key? key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    CarouselTransitionBuilder? transitionBuilder,
  })  : transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        childrenDelegate = new CarouselChildBuildDelegate(itemBuilder, itemCount),
        super(key: key);

  Carousel.custom({
    Key? key,
    this.scrollDirection = _defaultScrollDirection,
    this.reverse = _defaultReverse,
    this.controller,
    this.physics,
    this.pageSnapping = _defaultPageSnapping,
    this.onPageChanged,
    this.onIndexChanged,
    required this.childrenDelegate,
    CarouselTransitionBuilder? transitionBuilder,
  })  : transitionBuilder = transitionBuilder ?? _defaultTransitionBuilder,
        super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class CarouselController {

  final int itemCount;

  final bool infiniteScroll;

  final int pageOffset;

  final PageController pageController;

  CarouselController({
    required this.itemCount,
    int initialIndex = 0,
    bool keepPage = true,
    double viewportFraction = 0.8,
    this.infiniteScroll = _defaultInfiniteScroll,
    int pageOffset = _defaultPageOffset,
  }) :  pageOffset = (infiniteScroll ? pageOffset : 0),
        pageController = PageController(
          initialPage: (infiniteScroll ? pageOffset : 0) + initialIndex,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

  double get currentIndex {
    return itemCount <= 0 ? -1 : (currentPage - pageOffset) % itemCount;
  }

  double get currentPage {

    final page = pageController.position.haveDimensions ? pageController.page : null;
    if (page != null) {
      return page;
    }

    final storageContext = pageController.position.context.storageContext;
    final pageStored = PageStorage.of(storageContext)?.readState(storageContext) as double?;
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

  Future<void> nextPage({required Duration duration, required Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  Future<void> previousPage({required Duration duration, required Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  Future<void> animateToPage(int page, {required Duration duration, required Curve curve}) {
    return pageController.animateToPage(page, duration: duration, curve: curve);
  }

  Future<void> animateToIndex(int index, {required Duration duration, required Curve curve}) {
    final page = indexToPage(index);
    return pageController.animateToPage(page, duration: duration, curve: curve);
  }

  @mustCallSuper
  void dispose() {
    pageController.dispose();
  }
}

class _CarouselState extends State<Carousel> {

  CarouselController? _controller;

  CarouselController get _effectiveController => widget.controller ?? _controller!;

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
        _controller!.dispose();
        _controller = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: _effectiveController.pageController,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: (page) {
        widget.onPageChanged?.call(page);
        widget.onIndexChanged?.call(_effectiveController.pageToIndex(page));
      },
      itemBuilder: (context, index) => _buildAnimatedPage(context, index),
      itemCount: _effectiveController.infiniteScroll ? null : widget.childrenDelegate.itemCount,
    );
  }

  Widget _buildAnimatedPage(BuildContext context, int page) {

    final index = _effectiveController.pageToIndex(page);
    if (index < 0) {
      return SizedBox();
    }

    return AnimatedBuilder(
      animation: _effectiveController.pageController,
      builder: (context, child) => widget.transitionBuilder(
        context,
        child,
        page,
        _effectiveController.currentPage,
        index,
        _effectiveController.currentIndex,
        widget.childrenDelegate.itemCount,
      ),
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

  const CarouselChildListDelegate(this.children);

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

  const CarouselChildBuildDelegate(this.builder, this.itemCount);

  @override
  Widget build(BuildContext context, int index) {
    return builder(context, index);
  }
}
