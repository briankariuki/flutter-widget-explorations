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

  Offset startOffset = Offset.zero;
  Offset endOffset = Offset.zero;

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
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  void openCard(
    OpenCard card,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final obj = card.key.currentContext?.findRenderObject() as RenderBox;

      final pos = obj.localToGlobal(Offset.zero);

      setState(() {
        selectedCard = card;
        startOffset = Offset(pos.dx, pos.dy);
      });
    });

    animationController.forward();
  }

  void closeCard() {
    animationController.reverse().whenComplete(
          () => setState(
            () {
              selectedCard = null;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardWidth = (size.width / 2) - 16.0 + 8.0;
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 24.0),
                      shrinkWrap: true,
                      itemCount: _cards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        mainAxisExtent: 280.0,
                      ),
                      itemBuilder: (_, index) {
                        final item = _cards[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                AnimatedBuilder(
                                  animation: animationController,
                                  builder: (_, child) {
                                    return Opacity(
                                      opacity: selectedCard?.key == item.key
                                          ? lerpDouble(
                                              1,
                                              0,
                                              Curves.easeInOut.transform(const Interval(0.000, 0.100).transform(animationController.value)),
                                            )!
                                          : 1,
                                      child: child,
                                    );
                                  },
                                  child: Container(
                                    key: item.key,
                                    height: 240.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        openCard(
                                          item,
                                        );
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
                  ),
                  //selectedCard != null
                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: animationController,
                        builder: (_, child) {
                          return Opacity(
                            opacity: lerpDouble(
                              0,
                              1,
                              Curves.easeInOut.transform(const Interval(0.000, 0.050).transform(animationController.value)),
                            )!,
                            child: Transform(
                              //alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..translate(
                                  lerpDouble(
                                    startOffset.dx,
                                    endOffset.dx,
                                    Curves.easeInOut.transform(animationController.value),
                                  )!,
                                  lerpDouble(
                                    startOffset.dy - kToolbarHeight,
                                    endOffset.dy,
                                    Curves.easeInOut.transform(animationController.value),
                                  )!,
                                  0,
                                ),
                              // ..scale(
                              //   lerpDouble(
                              //     0.5,
                              //     1,
                              //     Curves.easeInOut.transform(animationController.value),
                              //   ),
                              // ),
                              child: SizedBox(
                                height: lerpDouble(
                                  240,
                                  size.height / 2,
                                  Curves.easeInOut.transform(animationController.value),
                                ),
                                width: lerpDouble(
                                  cardWidth,
                                  size.width,
                                  Curves.easeInOut.transform(animationController.value),
                                ),
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(4.0),
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
                      )
                    ],
                  )
                  // : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          AnimationSlider(
            onChanged: (value) => animationController.value = value,
            controller: animationController,
          )
        ],
      ),
    );
  }
}
