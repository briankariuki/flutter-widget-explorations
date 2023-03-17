import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/core/widgets/custom_scroll_behavior.dart';
import 'package:flutter_reactive_programming/core/widgets/widgets.dart';

import 'open_card_data.dart';

class OpenCardPage extends StatefulWidget {
  static const String routeName = '/open-card';
  const OpenCardPage({super.key});

  @override
  State<OpenCardPage> createState() => _OpenCardPageState();
}

class _OpenCardPageState extends State<OpenCardPage> with SingleTickerProviderStateMixin {
  List<OpenCard> _cards = [];

  final ScrollController scrollController = ScrollController();
  late AnimationController animationController;

  OpenCard? selectedCard;

  Offset overlayStartOffset = Offset.zero;
  Offset gridStartOffset = Offset.zero;
  Offset overlayEndOffset = Offset.zero;

  final GlobalObjectKey overlayCardKey = const GlobalObjectKey("overlay-card-key");

  final cardHeight = 280.0;
  final cardImageHeight = 240.0;
  final kHeaderHeight = 160.0;

  final horizontalPadding = 8.0;
  double scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _cards = List.generate(
      30,
      (index) => OpenCard(title: 'Name', key: GlobalObjectKey('$index-card-key')),
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animationController.addListener(listener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController
      ..removeListener(listener)
      ..dispose();

    super.dispose();
  }

  void openCard(OpenCard card, int index, double scale, double cardWidth) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final obj = card.key.currentContext?.findRenderObject() as RenderBox;

      final pos = obj.localToGlobal(Offset.zero);

      final size = MediaQuery.of(context).size;

      Offset _overlayStartOffset = Offset.zero;

      Offset _gridStartOffset = Offset.zero;

      //final _posTopCenter = Offset(pos.dx + (obj.size.width / 2), pos.dy - kToolbarHeight + (obj.size.height / 2));
      final _posTopLeft = Offset(pos.dx - horizontalPadding, pos.dy - kHeaderHeight);
      //final _posTopRight = Offset(pos.dx + obj.size.width, pos.dy - kHeaderHeight);
      final _posBottomRight = Offset(pos.dx - horizontalPadding + obj.size.width, pos.dy - kHeaderHeight + (obj.size.height));
      final _posBottomLeft = Offset(pos.dx - horizontalPadding, pos.dy - kHeaderHeight + (obj.size.height));

      final _inTopLeftQuad = _posBottomLeft.dy < (size.height / 2) && (_posBottomLeft.dx + horizontalPadding) < (size.width / 2);
      final _inTopRightQuad = _posBottomLeft.dy < (size.height / 2) && (_posBottomLeft.dx + horizontalPadding) > (size.width / 2);

      final _inBottomLeftQuad = _posBottomLeft.dy > (size.height / 2) && (_posBottomLeft.dx + horizontalPadding) < (size.width / 2);
      final _inBottomRightQuad = _posBottomLeft.dy > (size.height / 2) && (_posBottomLeft.dx + horizontalPadding) > (size.width / 2);

      // print("${_posBottomLeft.dy} > (${size.height / 2})");
      // print("${_posBottomLeft.dx} < (${size.width / 2})");

      if (_inTopLeftQuad) {
        print("is in _inTopLeftQuad");

        _overlayStartOffset = _posTopLeft;

        // _gridStartOffset = _posTopLeft;
        _gridStartOffset = _posBottomLeft;
      }
      if (_inTopRightQuad) {
        print("is in _inTopRightQuad");

        _overlayStartOffset = _posTopLeft;

        //_gridStartOffset = _posTopRight;

        _gridStartOffset = _posBottomRight;
      }
      if (_inBottomLeftQuad) {
        print("is in _inBottomLeftQuad");
        _gridStartOffset = _posBottomLeft;

        _overlayStartOffset = _posTopLeft;
      }
      if (_inBottomRightQuad) {
        print("is in _inBottomRightQuad");

        _overlayStartOffset = _posTopLeft;

        _gridStartOffset = _posBottomRight;
      }

      final _overlayEndOffset = Offset(0, scale * (_overlayStartOffset.dy - _gridStartOffset.dy) + _gridStartOffset.dy);

      final _scrollOffset = _overlayEndOffset.dy / ((size.width) / (cardWidth));

      setState(() {
        selectedCard = card;
        overlayStartOffset = _overlayStartOffset;
        overlayEndOffset = _overlayEndOffset;
        gridStartOffset = _gridStartOffset;
        scrollOffset = _scrollOffset;
      });

      print("overlayStart $overlayStartOffset");
      print("gridStart $gridStartOffset");
      print("overlayEnd $_overlayEndOffset");
      print("scrollOffset $_scrollOffset");
    });

    animationController.forward();
  }

  void closeCard() {
    // animationController.reverse();
    animationController.reverse().whenComplete(
          () => setState(
            () {
              selectedCard = null;
            },
          ),
        );
  }

  void listener() {
    scrollController.jumpTo(lerpDouble(
      0,
      scrollOffset <= 0 ? 0 : scrollOffset,
      Curves.easeInOut.transform(animationController.value),
    )!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardWidth = (size.width / 2) - (horizontalPadding / 2);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarBrightness: Brightness.dark,
        //   ),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0.0,
        //   iconTheme: const IconThemeData(
        //     color: Colors.white,
        //   ),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Container(
                  height: lerpDouble(
                    kHeaderHeight,
                    0.0,
                    // Curves.easeInOut.transform(animationController.value),

                    Curves.easeInOut.transform(const Interval(0.500, 0.900).transform(animationController.value)),
                  )!,
                  color: Colors.red[100],
                  child: child,
                );
              },
              child: SafeArea(
                bottom: false,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      transformHitTests: true,
                      offset: Offset(
                        0,
                        lerpDouble(
                          0.0,
                          -kHeaderHeight,
                          Curves.easeInOut.transform(const Interval(0.000, 0.400).transform(animationController.value)),
                        )!,
                      ),
                      child: Opacity(
                        opacity: lerpDouble(
                          1,
                          0,
                          Curves.easeInOut.transform(const Interval(0.000, 0.400).transform(animationController.value)),
                        )!,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    height: kHeaderHeight,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                  12.0 -
                                      lerpDouble(
                                        0.0,
                                        48.0,
                                        Curves.easeInOut.transform(animationController.value),
                                      )!,
                                  0),
                              child: Opacity(
                                opacity: lerpDouble(
                                  1,
                                  0,
                                  Curves.easeInOut.transform(const Interval(0.000, 0.400).transform(animationController.value)),
                                )!,
                                child: child,
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200.0),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(200.0),
                              ),
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Players',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                overflow: TextOverflow.fade,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'Browse all English Premier League Players',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                overflow: TextOverflow.fade,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (_, child) {
                        return Transform(
                          origin: Offset(
                            gridStartOffset.dx,
                            gridStartOffset.dy,
                          ),
                          transform: Matrix4.identity()
                            ..scale(
                              lerpDouble(
                                1,
                                (size.width) / (cardWidth),
                                Curves.easeInOut.transform(animationController.value),
                              ),
                            ),
                          child: Container(
                            color: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(
                              horizontal: lerpDouble(
                                horizontalPadding,
                                0.0,
                                Curves.easeInOut.transform(animationController.value),
                              )!,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: _cards.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              mainAxisExtent: cardHeight,
                            ),
                            itemBuilder: (_, index) {
                              final item = _cards[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AnimatedBuilder(
                                    animation: animationController,
                                    builder: (_, child) {
                                      return Opacity(
                                        opacity: selectedCard?.key.value == item.key.value
                                            ? lerpDouble(
                                                1,
                                                1,
                                                Curves.easeInOut.transform(const Interval(0.000, 0.100).transform(animationController.value)),
                                              )!
                                            : 1,
                                        child: child,
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          key: item.key,
                                          height: cardImageHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[700],
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                openCard(item, index, (size.width) / (cardWidth), cardWidth);
                                              },
                                              highlightColor: Colors.white.withOpacity(0.08),
                                              splashColor: Colors.white.withOpacity(0.06),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Name',
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                        const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) {
                                return IgnorePointer(
                                  ignoring: true,
                                  child: Opacity(
                                    opacity: lerpDouble(
                                      0,
                                      1,
                                      Curves.easeInOut.transform(const Interval(0.000, 0.650).transform(animationController.value)),
                                    )!,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              return Positioned(
                                key: overlayCardKey,
                                top: overlayStartOffset.dy -
                                    lerpDouble(
                                      0,
                                      scrollOffset,
                                      Curves.easeInOut.transform(animationController.value),
                                    )!,
                                left: overlayStartOffset.dx,
                                child: Opacity(
                                  opacity: lerpDouble(
                                    0,
                                    1,
                                    Curves.easeInOut.transform(const Interval(0.000, 0.050).transform(animationController.value)),
                                  )!,
                                  child: GestureDetector(
                                    onTap: () => print("tappped"),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: cardImageHeight,
                                          width: cardWidth -
                                              lerpDouble(
                                                horizontalPadding,
                                                0.0,
                                                Curves.easeInOut.transform(animationController.value),
                                              )!,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[500],
                                              borderRadius: BorderRadius.circular(
                                                lerpDouble(
                                                  4.0,
                                                  0.0,
                                                  Curves.easeInOut.transform(const Interval(0.800, 1.000).transform(animationController.value)),
                                                )!,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  right: 8.0,
                                                  top: 8.0,
                                                  child: IconButton(
                                                    onPressed: () => closeCard(),
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white24,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        child!,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: const [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      children: [
                        AnimationSlider(
                          onChanged: (value) => animationController.value = value,
                          controller: animationController,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            scrollController.animateTo(38.0, duration: const Duration(milliseconds: 150), curve: Curves.bounceIn);
                          },
                          child: const Text('Scroll'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
