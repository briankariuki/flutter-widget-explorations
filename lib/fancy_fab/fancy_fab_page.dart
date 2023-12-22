import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_explorations/fancy_fab/fancy_fab_data.dart';

class FancyFabPage extends StatefulWidget {
  static const String routeName = '/fancy-fab';

  const FancyFabPage({super.key});

  @override
  State<FancyFabPage> createState() => _FancyFabPageState();
}

class _FancyFabPageState extends State<FancyFabPage> with SingleTickerProviderStateMixin {
  final _iconSize = 24.0;
  final _fabRadius = 24.0;
  final _fabPadding = 8.0;

  double value = 0.0;

  AnimationController? animationController;

  //Delay time for all fab items
  static const _initialDelayTime = Duration(milliseconds: 15);
  static const _fabIconAnimationTime = Duration(milliseconds: 1200);
  static const _staggerTime = Duration(milliseconds: 60);

  final animationDuration = const Duration(milliseconds: 600);

  final List<Interval> _fabIconsIntervals = [];

  @override
  void initState() {
    super.initState();

    createAnimationIntervals();

    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    animationController?.addListener(_listener);
  }

  @override
  void dispose() {
    animationController
      ?..removeListener(_listener)
      ..dispose();
    super.dispose();
  }

  void createAnimationIntervals() {
    for (int i = 0; i < icons.length - 1; i++) {
      final _fabIconAnimationStartTime = _initialDelayTime + (_staggerTime * i);
      final _fabIconAnimationEndTime = _fabIconAnimationStartTime + _fabIconAnimationTime;

      _fabIconsIntervals.add(
        Interval(
          _fabIconAnimationStartTime.inMilliseconds / animationDuration.inMilliseconds,
          _fabIconAnimationEndTime.inMilliseconds.clamp(0, animationDuration.inMilliseconds) / animationDuration.inMilliseconds,
        ),
      );

      print("fab:$i startTime:$_fabIconAnimationStartTime endTime:$_fabIconAnimationEndTime duration:$animationDuration");
    }
  }

  void onTap() {
    if (animationController!.status == AnimationStatus.completed) {
      animationController?.reverse();
    } else {
      animationController?.forward();
    }
  }

  void _listener() {
    value = animationController!.value;

    //stiffness 500 damping 15

    // final duration = Duration(
    //   milliseconds: lerpDouble(0, animationController!.duration!.inMilliseconds.toDouble(), animationController!.value)!.floor(),
    // );

    // print(duration);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          Expanded(child: Container()),
          SafeArea(
            child: SizedBox(
              width: size.width,
              height: 160.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...icons
                      .asMap()
                      .map(
                        (i, icon) {
                          return MapEntry(
                            i,
                            AnimatedBuilder(
                                animation: animationController!,
                                builder: (_, child) {
                                  final position = i * ((_fabRadius * 2) + _fabPadding) + (size.width - ((_fabRadius * 2) + _fabPadding) * icons.length) / 2;

                                  final startPosition = (size.width - ((_fabRadius * 2) + _fabPadding) * icons.length) / 2;

                                  return i == icons.length - 1
                                      ? Positioned(
                                          left: lerpDouble(
                                            startPosition,
                                            position,
                                            Curves.fastOutSlowIn.transform(animationController!.value),
                                          ),
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..scale(lerpDouble(
                                                1.1,
                                                1,
                                                Curves.fastOutSlowIn.transform(animationController!.value),
                                              )!),
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: _fabRadius,
                                                  backgroundColor: icon.color,
                                                  child: Center(
                                                    child: Transform.rotate(
                                                      angle: lerpDouble(
                                                        pi / 4,
                                                        0,
                                                        Curves.fastOutSlowIn.transform(animationController!.value),
                                                      )!,
                                                      child: Icon(
                                                        icon.icon.icon,
                                                        size: _iconSize,
                                                        color: icon.icon.color,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Material(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(_fabRadius),
                                                    ),
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () => onTap(),
                                                      radius: _fabRadius,
                                                      borderRadius: BorderRadius.circular(_fabRadius),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Positioned(
                                          left: lerpDouble(
                                            position - (10 * i),
                                            position,
                                            Curves.easeInOutBack.transform(
                                              _fabIconsIntervals[i].transform(animationController!.value),
                                            ),
                                          ),
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..scale(lerpDouble(
                                                0,
                                                1,
                                                Curves.elasticOut.transform(_fabIconsIntervals[i].transform(animationController!.value)),
                                              )!),
                                            child: CircleAvatar(
                                              radius: _fabRadius,
                                              backgroundColor: icon.color,
                                              child: Center(
                                                child: Transform.rotate(
                                                  angle: lerpDouble(
                                                    pi / 4,
                                                    0,
                                                    Curves.easeInOutBack.transform(_fabIconsIntervals[i].transform(animationController!.value)),
                                                  )!,
                                                  child: Icon(
                                                    icon.icon.icon,
                                                    size: _iconSize,
                                                    color: icon.icon.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                }),
                          );
                        },
                      )
                      .values
                      .toList()
                ],
              ),
            ),
          ),

          //For debugging animation controller
          // AnimationSlider(
          //   onChanged: (value) => animationController!.value = value,
          //   controller: animationController!,
          // )
        ],
      ),
    );
  }
}
