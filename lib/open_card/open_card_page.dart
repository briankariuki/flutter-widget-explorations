import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/core/widgets/custom_scroll_behavior.dart';
import 'package:flutter_reactive_programming/core/widgets/widgets.dart';
import 'package:flutter_reactive_programming/open_card/widgets/card_content_widget.dart';
import 'package:flutter_reactive_programming/util/image.dart';

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
  final kHeaderHeight = 200.0;

  final horizontalPadding = 8.0;
  double scrollOffset = 0.0;

  double scrollPosition = 0.0;

  final animationCurve = const Cubic(0.6, 0.05, -0.01, 0.9);
  final animationDuration = const Duration(milliseconds: 600);

  ///static const Cubic easeCurve = Cubic(0.6, 0.05, -0.01, 0.9);

  @override
  void initState() {
    super.initState();

    _cards = List.generate(
      collections.length,
      (index) => OpenCard(
        title: collections[index].name,
        key: GlobalObjectKey('$index-card-key'),
        collection: collections[index],
      ),
    );

    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
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
    scrollPosition = scrollController.offset;

    // if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
    //   scrollPosition = 0.0;
    // } else {
    //   scrollPosition = scrollController.offset;
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final obj = card.key.currentContext?.findRenderObject() as RenderBox;

      final pos = obj.localToGlobal(Offset.zero);

      final size = MediaQuery.of(context).size;

      Offset _overlayStartOffset = Offset.zero;
      Offset _overlayEndOffset = Offset.zero;

      Offset _gridStartOffset = Offset.zero;

      //final _posTopCenter = Offset(pos.dx + (obj.size.width / 2), pos.dy - kToolbarHeight + (obj.size.height / 2));
      final _posTopLeft = Offset(pos.dx, pos.dy - kHeaderHeight);
      //final _posTopRight = Offset(pos.dx + obj.size.width, pos.dy - kHeaderHeight);
      final _posBottomRight = Offset(pos.dx + obj.size.width, pos.dy - kHeaderHeight + (obj.size.height));
      final _posBottomLeft = Offset(pos.dx, pos.dy - kHeaderHeight + (obj.size.height));

      final _inTopLeftQuad = _posBottomLeft.dy < (size.height / 2) && (_posBottomLeft.dx) < (size.width / 2);
      final _inTopRightQuad = _posBottomLeft.dy < (size.height / 2) && (_posBottomLeft.dx) > (size.width / 2);

      final _inBottomLeftQuad = _posBottomLeft.dy > (size.height / 2) && (_posBottomLeft.dx) < (size.width / 2);
      final _inBottomRightQuad = _posBottomLeft.dy > (size.height / 2) && (_posBottomLeft.dx) > (size.width / 2);

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

        _gridStartOffset = Offset(_posBottomRight.dx, _posBottomRight.dy);

        _overlayStartOffset = Offset(_posTopLeft.dx, _posTopLeft.dy);
      }

      _overlayEndOffset = Offset(0, scale * (_overlayStartOffset.dy - _gridStartOffset.dy) + _gridStartOffset.dy);

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
    animationController.reverse().whenComplete(() => Future.delayed(const Duration(milliseconds: 100), () {
          setState(
            () {
              selectedCard = null;
            },
          );
        }));
  }

  void listener() {
    scrollController.jumpTo(scrollPosition +
        lerpDouble(
          0,
          scrollOffset <= 0 ? 0 : scrollOffset,
          animationCurve.transform(animationController.value),
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
                    animationCurve.transform(const Interval(0.000, 0.900).transform(animationController.value)),
                  )!,
                  color: Colors.black,
                  child: Transform.translate(
                    transformHitTests: true,
                    offset: Offset(
                      0,
                      lerpDouble(
                        0.0,
                        -kHeaderHeight,
                        animationCurve.transform(const Interval(0.000, 0.800).transform(animationController.value)),
                      )!,
                    ),
                    child: Opacity(
                      opacity: lerpDouble(
                        1,
                        0,
                        animationCurve.transform(const Interval(0.000, 0.800).transform(animationController.value)),
                      )!,
                      child: child,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: NewtworkImageWrapper(
                      imageUrl: 'https://i.seadn.io/gcs/files/a6749ad57d276cd2149eb8bf7fad1dee.png?auto=format&w=384',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 24.0,
                          sigmaY: 24.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0 + kToolbarHeight + 40.0,
                    bottom: 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Wrap(
                          // wrapCrossAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.center,

                          direction: Axis.vertical,
                          children: [
                            Text(
                              'NFT Collections',
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
                              'Browse the top NFT collections of the week.',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                              overflow: TextOverflow.fade,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: kToolbarHeight,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            12.0 -
                                lerpDouble(
                                  0.0,
                                  48.0,
                                  animationCurve.transform(animationController.value),
                                )!,
                            0,
                          ),
                          child: Opacity(
                            opacity: lerpDouble(
                              1,
                              0,
                              animationCurve.transform(const Interval(0.000, 0.400).transform(animationController.value)),
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
                  )
                ],
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
                                animationCurve.transform(animationController.value),
                              ),
                            ),
                          child: Container(
                            color: Colors.white.withOpacity(0.08),
                            // padding: EdgeInsets.symmetric(
                            //   horizontal: lerpDouble(
                            //     horizontalPadding,
                            //     0.0,
                            //     animationCurve.transform(animationController.value),
                            //   )!,
                            // ),
                            child: child,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          GridView.builder(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
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
                              return AnimatedBuilder(
                                animation: animationController,
                                builder: (_, child) {
                                  return Opacity(
                                    opacity: selectedCard?.key.value == item.key.value
                                        ? lerpDouble(
                                            1,
                                            0,
                                            animationCurve.transform(const Interval(0.000, 0.100).transform(animationController.value)),
                                          )!
                                        : 1,
                                    child: child,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          key: item.key,
                                          height: cardImageHeight,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4.0),
                                            child: NewtworkImageWrapper(
                                              imageUrl: item.collection.imageUrl,
                                              height: cardImageHeight,
                                              fit: BoxFit.cover,
                                            ),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item.collection.name,
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                    color: Colors.white,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
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
                                ),
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
                                      animationCurve.transform(const Interval(0.000, 0.650).transform(animationController.value)),
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
                          selectedCard != null
                              ? AnimatedBuilder(
                                  animation: animationController,
                                  builder: (context, child) {
                                    return Positioned(
                                      key: overlayCardKey,
                                      top: overlayStartOffset.dy -
                                          lerpDouble(
                                            0,
                                            scrollOffset,
                                            animationCurve.transform(animationController.value),
                                          )!,
                                      left: overlayStartOffset.dx,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Opacity(
                                            opacity: lerpDouble(
                                              0,
                                              1,
                                              animationCurve.transform(const Interval(0.000, 0.050).transform(animationController.value)),
                                            )!,
                                            child: SizedBox(
                                              height: cardImageHeight,
                                              width: cardWidth,
                                              // lerpDouble(
                                              //   horizontalPadding,
                                              //   0.0,
                                              //   animationCurve.transform(animationController.value),
                                              // )!,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(
                                                    lerpDouble(
                                                      8.0,
                                                      0.0,
                                                      animationCurve.transform(const Interval(0.800, 1.000).transform(animationController.value)),
                                                    )!,
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(
                                                        lerpDouble(
                                                          4.0,
                                                          0.0,
                                                          animationCurve.transform(const Interval(0.800, 1.000).transform(animationController.value)),
                                                        )!,
                                                      ),
                                                      child: NewtworkImageWrapper(
                                                        imageUrl: selectedCard!.collection.imageUrl,
                                                        height: cardImageHeight,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  selectedCard != null
                      ? AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: lerpDouble(
                                overlayStartOffset.dy + cardImageHeight,
                                size.height / 2,
                                animationCurve.transform(animationController.value),
                              ),
                              left: lerpDouble(
                                overlayStartOffset.dx,
                                0.0,
                                animationCurve.transform(animationController.value),
                              ),
                              child: SizedBox(
                                height: lerpDouble(
                                  300.0,
                                  size.height,
                                  animationCurve.transform(animationController.value),
                                ),
                                width: lerpDouble(
                                  cardWidth,
                                  size.width,
                                  animationCurve.transform(animationController.value),
                                ),
                                child: Opacity(
                                  opacity: lerpDouble(
                                    0,
                                    1,
                                    animationCurve.transform(const Interval(0.100, 0.800).transform(animationController.value)),
                                  )!,
                                  child: child,
                                ),
                              ),
                            );
                          },
                          child: CardContentWidget(
                            size: size,
                            card: selectedCard!,
                          ),
                        )
                      : const SizedBox.shrink(),
                  selectedCard != null
                      ? AnimatedBuilder(
                          animation: animationController,
                          builder: (context, _) {
                            return Positioned(
                              top: lerpDouble(
                                overlayStartOffset.dy + 8.0,
                                kToolbarHeight + 16.0,
                                animationCurve.transform(animationController.value),
                              ),
                              left: lerpDouble(
                                overlayStartOffset.dx +
                                    cardWidth -
                                    lerpDouble(
                                      40.0,
                                      48.0,
                                      animationCurve.transform(animationController.value),
                                    )!,
                                size.width - 64.0,
                                animationCurve.transform(animationController.value),
                              ),
                              child: Opacity(
                                opacity: lerpDouble(
                                  0,
                                  1,
                                  animationCurve.transform(const Interval(0.000, 0.500).transform(animationController.value)),
                                )!,
                                child: SizedBox(
                                  height: lerpDouble(
                                    32.0,
                                    48.0,
                                    animationCurve.transform(animationController.value),
                                  ),
                                  width: lerpDouble(
                                    32.0,
                                    48.0,
                                    animationCurve.transform(animationController.value),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200.0),
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(200.0),
                                      ),
                                      color: Colors.white.withOpacity(0.24),
                                      child: IconButton(
                                        iconSize: lerpDouble(
                                          12.0,
                                          24.0,
                                          animationCurve.transform(animationController.value),
                                        ),
                                        onPressed: () => closeCard(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                  // Positioned(
                  //   bottom: 0.0,
                  //   left: 0.0,
                  //   right: 0.0,
                  //   child: Row(
                  //     children: [
                  //       AnimationSlider(
                  //         onChanged: (value) => animationController.value = value,
                  //         controller: animationController,
                  //       ),
                  //       ElevatedButton(
                  //         onPressed: () {
                  //           scrollController.animateTo(38.0, duration: const Duration(milliseconds: 150), curve: Curves.bounceIn);
                  //         },
                  //         child: const Text('Scroll'),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
