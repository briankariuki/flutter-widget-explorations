import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/dynamic_tab_indicator/dynamic_tab_indicator_data.dart';
import 'package:flutter_reactive_programming/util/image.dart';

enum ScrollDirection { left, right, none }

class DynamicTabIndicatorPage extends StatefulWidget {
  static const String routeName = '/dynamic-tab-indicator';

  const DynamicTabIndicatorPage({super.key});

  @override
  State<DynamicTabIndicatorPage> createState() => _DynamicTabIndicatorPageState();
}

class _DynamicTabIndicatorPageState extends State<DynamicTabIndicatorPage> with SingleTickerProviderStateMixin {
  List<PageTab> pages = [];

  double pagePercent = 0.0;
  int currentPage = 0;

  PageController pageController = PageController();

  ScrollDirection direction = ScrollDirection.none;

  AnimationController? animationController;

  PageTab? selectedTab;

  @override
  void initState() {
    super.initState();

    pages = [...tabs];

    currentPage = 0;

    selectedTab = pages[0];

    pageController = PageController();

    pageController.addListener(scrollListener);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    animationController?.forward();
  }

  @override
  void dispose() {
    pageController
      ..removeListener(scrollListener)
      ..dispose();
    animationController?.dispose();
    super.dispose();
  }

  void scrollListener() {
    if ((pageController.page! < currentPage)) {
      direction = ScrollDirection.right;
    } else if ((pageController.page! > currentPage)) {
      direction = ScrollDirection.left;
    } else {
      direction = ScrollDirection.none;
    }

    currentPage = pageController.page!.floor();

    pagePercent = (pageController.page! - currentPage).abs();

    setState(() {});
  }

  void onPageChanged(int index) {
    animationController?.reset();

    animationController?.forward();

    setState(() {
      selectedTab = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              onPageChanged: (value) {
                onPageChanged(value);
              },
              controller: pageController,
              itemCount: pages.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final page = pages[index];

                return AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: lerpDouble(
                        1.08,
                        1.0,
                        Curves.ease.transform(animationController!.value),
                      ),
                      child: child,
                    );
                  },
                  child: NewtworkImageWrapper(
                    imageUrl: page.imageUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [
                      0.1,
                      0.3,
                      0.5,
                      0.9,
                    ],
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 24.0,
                        sigmaY: 24.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PhotoSplash',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'Discover curated photos powered by AI',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      PageTabsWidget(
                        tabs: tabs,
                        pagePercent: pagePercent,
                        currentPage: currentPage,
                        screenSize: size,
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Divider(
                        height: 1.0,
                        thickness: 0.8,
                        color: Colors.white.withOpacity(0.64),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 24.0,
            right: 24.0,
            child: AnimatedBuilder(
              animation: animationController!,
              builder: (_, child) {
                return Opacity(
                  opacity: lerpDouble(
                    0,
                    1,
                    Curves.ease.transform(animationController!.value),
                  )!,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      lerpDouble(
                        56,
                        0,
                        Curves.ease.transform(animationController!.value),
                      )!,
                    ),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedTab!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    selectedTab!.description,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          height: 1.61,
                        ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => {},
                    icon: const Icon(Icons.explore),
                    label: const Text('Explore Now'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      minimumSize: Size(size.width / 2, 48.0),
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PageTabsWidget extends StatefulWidget {
  final List<PageTab> tabs;

  final double pagePercent;
  final int currentPage;

  final Size screenSize;
  final double textScaleFactor;
  final TextStyle? textStyle;

  const PageTabsWidget({
    super.key,
    required this.tabs,
    required this.pagePercent,
    required this.currentPage,
    required this.screenSize,
    required this.textScaleFactor,
    required this.textStyle,
  });

  @override
  State<PageTabsWidget> createState() => _PageTabsWidgetState();
}

class _PageTabsWidgetState extends State<PageTabsWidget> {
  Map<String, TabData> tabsData = {};

  ScrollController scrollController = ScrollController();

  double currentOffset = 0.0;

  double tabsLength = 0.0;

  @override
  void initState() {
    super.initState();

    calculateTabSizes();

    currentOffset = 0.0;
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PageTabsWidget oldWidget) {
    Offset startPosition = Offset.zero;
    Offset endPosition = Offset.zero;

    TabData currentTab;
    TabData nextTab;

    currentTab = tabsData['${widget.currentPage}']!;
    nextTab = tabsData['${widget.currentPage == widget.tabs.length - 1 ? widget.currentPage : widget.currentPage + 1}']!;

    double distanceToMove = nextTab.position!.dx - (widget.screenSize.width / 2);

    endPosition = Offset(distanceToMove, 0);
    startPosition = Offset(currentTab.position!.dx - (widget.screenSize.width / 2), 0);

    if (widget.currentPage == 0) {
      startPosition = Offset.zero;
    }

    currentOffset = -lerpDouble(startPosition.dx, endPosition.dx, widget.pagePercent)!;

    super.didUpdateWidget(oldWidget);
  }

  void calculateTabSizes() {
    var _tabsLength = 0.0;
    for (int i = 0; i < tabs.length; i++) {
      PageTab tab = tabs[i];

      final size = tab.getTabTextSize(
        style: widget.textStyle,
        textScaleFactor: widget.textScaleFactor,
        textDirection: TextDirection.ltr,
      );

      tabsData.addAll(
        {
          '$i': TabData(
            size: size,
            key: GlobalObjectKey('$i-tabkey'),
            position: Offset(_tabsLength + (size.width / 2) + 24.0, 0),
          ),
        },
      );

      _tabsLength = _tabsLength + size.width + 16.0;
    }

    tabsLength = _tabsLength + 32.0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 64.0,
          child: Stack(
            children: [
              AnimatedPositioned(
                top: 0.0,
                bottom: 0.0,
                left: currentOffset,
                duration: const Duration(milliseconds: 150),
                curve: Curves.ease,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tab = tabs[index];

                    return Container(
                      width: (tabsData['$index']?.size.width ?? 0.0) + 16.0,
                      key: tabsData['$index']?.key ?? GlobalObjectKey('$index-tabkey'),
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.ease,
                          opacity: widget.currentPage == index
                              ? lerpDouble(
                                  widget.currentPage == index ? 1.0 : 0.5,
                                  widget.currentPage == index ? 0.5 : 1.0,
                                  widget.pagePercent,
                                )!
                              : widget.currentPage + 1 == index && widget.pagePercent > 0.0
                                  ? lerpDouble(
                                      widget.currentPage == index ? 1.0 : 0.5,
                                      widget.currentPage == index ? 0.5 : 1.0,
                                      widget.pagePercent,
                                    )!
                                  : 0.65,
                          child: Text(
                            tab.title,
                            style: widget.textStyle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AnimatedPositioned(
                height: 4.0,
                bottom: 0.0,
                width: lerpDouble(
                  tabsData['${widget.currentPage}']?.size.width ?? 0.0,
                  tabsData['${widget.currentPage == widget.tabs.length - 1 ? widget.currentPage : widget.currentPage + 1}']?.size.width,
                  widget.pagePercent,
                ),
                duration: const Duration(milliseconds: 150),
                curve: Curves.ease,
                left: currentOffset +
                    lerpDouble(
                      (tabsData['${widget.currentPage}']!.position?.dx ?? 0.0) - (tabsData['${widget.currentPage}']!.size.width / 2),
                      (tabsData['${widget.currentPage == widget.tabs.length - 1 ? widget.currentPage : widget.currentPage + 1}']!.position?.dx ?? 0.0) -
                          (tabsData['${widget.currentPage == widget.tabs.length - 1 ? widget.currentPage : widget.currentPage + 1}']!.size.width / 2),
                      widget.pagePercent,
                    )!,
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: lerpDouble(
                    tabsData['${widget.currentPage}']!.size.width > 80.0 ? 24.0 : 16.0,
                    tabsData['${widget.currentPage == widget.tabs.length - 1 ? widget.currentPage : widget.currentPage + 1}']!.size.width > 80.0 ? 24.0 : 16.0,
                    widget.pagePercent,
                  )!),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabData {
  final Size size;
  final Offset? position;

  final GlobalKey key;

  TabData({
    required this.size,
    required this.key,
    required this.position,
  });
}
