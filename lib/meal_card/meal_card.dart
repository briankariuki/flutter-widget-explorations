import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

enum MoreState { open, closed }

enum EditState { open, closed }

class MealCardPage extends StatefulWidget {
  static const String routeName = '/meal-card';

  const MealCardPage({super.key});

  @override
  State<MealCardPage> createState() => _MealCardPageState();
}

class _MealCardPageState extends State<MealCardPage> with TickerProviderStateMixin {
  final Color greyBackground = const Color(0xfff0f0f0);

  late AnimationController moreController;
  late AnimationController editController;
  late AnimationController doneController;
  late AnimationController chipController;

  final animationDuration = const Duration(milliseconds: 600);

  MoreState moreState = MoreState.closed;
  EditState editState = EditState.closed;

  double moreAnimationValue = 0.0;
  double editAnimationValue = 0.0;
  double doneAnimationValue = 0.0;
  double chipContainerHeight = 48.0;

  final GlobalObjectKey moreButtonKey = const GlobalObjectKey("more-button-key");
  final GlobalObjectKey containerKey = const GlobalObjectKey("container-key");

  Offset moreButtonOffset = Offset.zero;

  final spring = const SpringDescription(
    mass: 1,
    stiffness: 72,
    damping: 8,
  );

  final velocity = 0.1;

  @override
  void initState() {
    super.initState();

    moreController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    editController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    chipController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    doneController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    moreController.addListener(_moreListener);
    editController.addListener(_editListener);
    doneController.addListener(_doneListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSize();
    });
  }

  @override
  void dispose() {
    moreController
      ..removeListener(_moreListener)
      ..dispose();

    editController
      ..removeListener(_editListener)
      ..dispose();

    doneController
      ..removeListener(_doneListener)
      ..dispose();

    chipController.dispose();
    super.dispose();
  }

  void showMore() {
    if (moreController.status == AnimationStatus.completed) {
      moreController.reverse();
      editController.value = 0.0;
      chipController.value = 0.0;
      doneController.value = 0.0;
    } else {
      moreController.forward();
    }
  }

  void _moreListener() {
    moreAnimationValue = moreController.value;
    if (moreController.status == AnimationStatus.dismissed) {
      setState(() {
        moreState = MoreState.closed;
      });
    }

    if (moreController.status == AnimationStatus.completed) {
      setState(() {
        moreState = MoreState.open;
      });
    }
  }

  void showEdit() {
    if (editController.status == AnimationStatus.completed) {
      editController.reverse();
    } else {
      editController.forward();
    }
  }

  void doneEdit() {
    chipController.reverse();
    doneController.forward();
  }

  void _editListener() {
    editAnimationValue = editController.value;
    if (editController.status == AnimationStatus.forward) {
      chipController.forward();

      setState(() {
        editState = EditState.open;
      });
    }

    if (editController.status == AnimationStatus.dismissed) {
      setState(() {
        editState = EditState.closed;
      });
    }
  }

  void _doneListener() {
    doneAnimationValue = doneController.value;
    if (doneController.status == AnimationStatus.completed) {
      editController.value = 0.0;
      chipController.value = 0.0;
      doneController.value = 0.0;
      moreController.value = 0.0;

      setState(() {
        editState = EditState.closed;
        moreState = MoreState.closed;
      });
    }
  }

  void _getSize() {
    final obj = moreButtonKey.currentContext?.findRenderObject() as RenderBox;

    final ancestor = containerKey.currentContext?.findRenderObject() as RenderBox;

    final pos = obj.localToGlobal(Offset.zero, ancestor: ancestor);

    setState(() {
      moreButtonOffset = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 5.0;
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 400.0,
          child: Container(
            key: containerKey,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: const Color(0xfff1f1f1).withOpacity(0.8),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xfff2f2f2).withOpacity(0.5),
                  spreadRadius: 1.0,
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Container(
                        width: 48.0,
                        height: 48.0,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: greyBackground,
                        ),
                        child: Image.asset(
                          "assets/images/banana.png",
                        ),
                      ),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lunch",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xff989898),
                                ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "Bananas",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: const Color(0xff464646),
                                  fontWeight: FontWeight.w700,
                                  height: 1.0,
                                ),
                          ),
                        ],
                      ),
                      trailing: Stack(
                        alignment: Alignment.centerRight,
                        clipBehavior: Clip.none,
                        children: [
                          AnimatedBuilder(
                            animation: Listenable.merge([editController, doneController]),
                            builder: (context, child) {
                              final yEdit = SpringSimulation(spring, 0, 40, velocity);
                              final xEdit = SpringSimulation(spring, 0, -20, velocity);

                              final yDone = SpringSimulation(spring, 0, -40, velocity);
                              final xDone = SpringSimulation(spring, 0, 20, velocity);

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(
                                  xEdit.x(editController.value) + xDone.x(doneController.value),
                                  yEdit.x(editController.value) + yDone.x(doneController.value),
                                  0,
                                ),
                                child: Opacity(
                                  opacity: max(
                                    lerpDouble(
                                      1,
                                      0,
                                      Curves.linear.transform(
                                        const Interval(0.0, 0.3).transform(editController.value),
                                      ),
                                    )!,
                                    lerpDouble(
                                      0,
                                      1,
                                      Curves.linear.transform(
                                        const Interval(0.0, 0.3).transform(doneController.value),
                                      ),
                                    )!,
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: ElevatedButton(
                              key: moreButtonKey,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.square(40.0),
                                elevation: 0.0,
                                shape: const CircleBorder(),
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                backgroundColor: greyBackground,
                              ),
                              onPressed: () => showMore(),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned.fill(
                                      child: AnimatedBuilder(
                                        animation: Listenable.merge([moreController, doneController]),
                                        builder: (context, child) {
                                          final rMore = SpringSimulation(spring, 0, -pi / 8, velocity);
                                          final rDone = SpringSimulation(spring, 0, pi / 8, velocity);
                                          return Transform.rotate(
                                            angle: rMore.x(moreController.value) + rDone.x(doneController.value),
                                            child: Opacity(
                                              opacity: max(
                                                  lerpDouble(
                                                    1,
                                                    0,
                                                    Curves.linear.transform(
                                                      const Interval(0.0, 0.3).transform(moreController.value),
                                                    ),
                                                  )!,
                                                  lerpDouble(
                                                    0,
                                                    1,
                                                    Curves.linear.transform(
                                                      const Interval(0.0, 0.3).transform(doneController.value),
                                                    ),
                                                  )!),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                          size: 16.0,
                                          color: Color(0xff757575),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: AnimatedBuilder(
                                        animation: Listenable.merge([moreController, doneController]),
                                        builder: (context, child) {
                                          final rMore = SpringSimulation(spring, -pi / 3, 0, velocity);
                                          final rDone = SpringSimulation(spring, 0, -pi / 3, velocity);
                                          return Transform.rotate(
                                            angle: rMore.x(moreController.value) + rDone.x(doneController.value),
                                            child: Opacity(
                                              opacity: lerpDouble(
                                                0,
                                                1,
                                                Curves.linear.transform(
                                                  const Interval(0.0, 0.3).transform(moreController.value),
                                                ),
                                              )!,
                                              child: Opacity(
                                                opacity: lerpDouble(
                                                  1,
                                                  0,
                                                  Curves.linear.transform(
                                                    const Interval(0.0, 0.3).transform(doneController.value),
                                                  ),
                                                )!,
                                                child: child,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 16.0,
                                          color: Color(0xff757575),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: chipController,
                      builder: (context, child) {
                        final xEdit = SpringSimulation(spring, 0, chipContainerHeight, velocity);
                        final yEdit = SpringSimulation(spring, chipContainerHeight, 0, velocity);

                        final topPaddingEdit = SpringSimulation(spring, 0, 8, velocity);
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: topPaddingEdit.x(chipController.value),
                          ),
                          child: SizedBox(
                            height: xEdit.x(chipController.value),
                            child: Transform(
                              transform: Matrix4.translationValues(
                                0,
                                yEdit.x(chipController.value),
                                0,
                              ),
                              child: Opacity(
                                opacity: lerpDouble(
                                  0,
                                  1,
                                  Curves.linear.transform(
                                    const Interval(0.0, 0.5).transform(chipController.value),
                                  ),
                                )!,
                                child: child,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(64.0, 40.0),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: const BorderSide(
                                  width: 1.5,
                                  color: Color(0xffaaaaaa),
                                ),
                              ),
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => {},
                            child: Text(
                              "Lunch",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff4a4a4a),
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(64.0, 40.0),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: BorderSide(
                                  width: 1.5,
                                  color: greyBackground,
                                ),
                              ),
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () => {},
                            child: Text(
                              "Snack",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xff828282),
                                    fontWeight: FontWeight.w700,
                                    height: 1.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),

                //Edit Button
                AnimatedBuilder(
                  animation: Listenable.merge([moreController, editController, doneController]),
                  builder: (context, child) {
                    final xMore = SpringSimulation(spring, moreButtonOffset.dx + 80.0, moreButtonOffset.dx - 84.0, velocity);
                    final yEdit = SpringSimulation(spring, 0, 60, velocity);
                    final xEdit = SpringSimulation(spring, 0, 40, velocity);

                    final xDone = SpringSimulation(spring, 0, -60, velocity);
                    final yDone = SpringSimulation(spring, 0, 20, velocity);
                    return Positioned(
                      left: xMore.x(moreController.value) + xEdit.x(editController.value) + yDone.x(doneController.value),
                      top: moreButtonOffset.dy + yEdit.x(editController.value) + xDone.x(doneController.value),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..scale(lerpDouble(
                            0.8,
                            1,
                            Curves.linear.transform(
                              const Interval(0.0, 0.3).transform(moreController.value),
                            ),
                          )!),
                        child: Opacity(
                          opacity: lerpDouble(
                            0,
                            1,
                            Curves.linear.transform(
                              const Interval(0.0, 0.3).transform(moreController.value),
                            ),
                          )!,
                          child: Opacity(
                            opacity: lerpDouble(
                              1,
                              0,
                              Curves.linear.transform(
                                const Interval(0.0, 0.3).transform(doneController.value),
                              ),
                            )!,
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(editState == EditState.closed ? 56.0 : 64.0, 40.0),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      backgroundColor: greyBackground,
                    ),
                    onPressed: () => editState == EditState.closed ? showEdit() : doneEdit(),
                    child: Text(
                      editState == EditState.closed ? "Edit" : "Done",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xff757575),
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                    ),
                  ),
                ),

                //Delete Button
                AnimatedBuilder(
                  animation: Listenable.merge([moreController, editController]),
                  builder: (context, child) {
                    final xMore = SpringSimulation(spring, moreButtonOffset.dx + 80.0, moreButtonOffset.dx - 132, velocity);

                    final yEdit = SpringSimulation(spring, 0, 40, velocity);
                    final xEdit = SpringSimulation(spring, 0, 20, velocity);

                    return Positioned(
                      left: xMore.x(moreController.value) + xEdit.x(editController.value),
                      top: moreButtonOffset.dy + yEdit.x(editController.value),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..scale(lerpDouble(
                            0.8,
                            1,
                            Curves.linear.transform(
                              const Interval(0.0, 0.3).transform(moreController.value),
                            ),
                          )!),
                        child: Opacity(
                          opacity: lerpDouble(
                            0,
                            1,
                            Curves.linear.transform(
                              const Interval(0.0, 0.3).transform(moreController.value),
                            ),
                          )!,
                          child: Opacity(
                            opacity: lerpDouble(
                              1,
                              0,
                              Curves.linear.transform(
                                const Interval(0.0, 0.3).transform(editController.value),
                              ),
                            )!,
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.square(40.0),
                      elevation: 0.0,
                      shape: const CircleBorder(),
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xfffff2f5),
                    ),
                    onPressed: () => {},
                    child: const Icon(
                      Icons.delete_outlined,
                      size: 20.0,
                      color: Color(0xffff0027),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
