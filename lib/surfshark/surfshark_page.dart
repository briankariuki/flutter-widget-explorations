import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/surfshark/surshark_page_data.dart';
import 'package:flutter_reactive_programming/util/image.dart';

class SurfsharkPage extends StatefulWidget {
  static const String routeName = '/surfshark';
  const SurfsharkPage({super.key});

  @override
  State<SurfsharkPage> createState() => _SurfsharkPageState();
}

class _SurfsharkPageState extends State<SurfsharkPage> with TickerProviderStateMixin {
  static int ringCount = 8;

  static Duration initialDelayTime = const Duration(milliseconds: 10);

  static Duration ringAnimationDuration = const Duration(milliseconds: 250);

  final ringsAnimationDuration = initialDelayTime + (ringAnimationDuration * ringCount);

  List<Interval> ringIntervals = [];
  List<Animation<double>> ringAnimations = [];
  List<AnimationController> ringAnimationControllers = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < ringCount; i++) {
      final _startTime = initialDelayTime * i;

      final _endTime = _startTime + ringAnimationDuration;

      final interval = Interval(
        _startTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
        _endTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
      );

      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: _startTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
        upperBound: _endTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
      );

      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            _startTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
            _endTime.inMilliseconds / ringsAnimationDuration.inMilliseconds,
            curve: Curves.linear,
          ),
        ),
      );

      if (i != 0 && i < ringCount - 1) {
        Future.delayed(Duration(milliseconds: i * initialDelayTime.inMilliseconds), () {
          ringAnimationControllers[i - 1].repeat(
            reverse: true,
            period: Duration(seconds: 1, milliseconds: (i * initialDelayTime.inMilliseconds)),
          );
        });
      } else {
        controller.repeat(
          reverse: true,
          period: Duration(seconds: 1, milliseconds: (i * initialDelayTime.inMilliseconds)),
        );
      }

      ringIntervals.add(interval);
      ringAnimations.add(animation);

      ringAnimationControllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var c in ringAnimationControllers) {
      c.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: tealBlue,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    color: tealBlue,
                    child: CustomPaint(
                      willChange: true,
                      painter: AnimatingCircles(
                        ringAnimations: ringAnimations,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.security,
                      color: tealBlue,
                      size: 80.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: bgDarkGray,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: const NewtworkImageWrapper(
                                      imageUrl: flagUrl,
                                      height: 36.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Text(
                                    'Kenya',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          color: bgGray3,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => {},
                                    icon: const Icon(
                                      Icons.star_border_rounded,
                                      color: bgGray3,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  IconButton(
                                    onPressed: () => {},
                                    icon: const Icon(
                                      Icons.search,
                                      color: bgGray3,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 16.0,
                                      height: 40.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: bgGray1.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: bgGray1,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.shield_outlined,
                                            color: tealBlue,
                                            size: 20.0,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            'Protected. Your connection is safe',
                                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  color: tealBlue,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () => {},
                                            icon: const Icon(
                                              Icons.expand_less,
                                              color: bgGray3,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  minimumSize: Size(size.width / 3, 48.0),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: tealBlue,
                                  foregroundColor: bgGray2,
                                  textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Pause'),
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  minimumSize: Size(size.width / 3, 48.0),
                                  shadowColor: Colors.transparent,
                                  backgroundColor: bgGray1,
                                  foregroundColor: tealBlue,
                                  textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Disconnect'),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
          color: bgDarkGray,
          height: kBottomNavigationBarHeight + 24.0,
          width: double.infinity,
          child: Row(
            children: const [
              Expanded(
                child: BottomNavbarItem(
                  isSelected: true,
                  icon: Icons.security,
                  text: 'Surfshark',
                ),
              ),
              Expanded(
                child: BottomNavbarItem(
                  isSelected: false,
                  icon: Icons.language,
                  text: 'Locations',
                ),
              ),
              Expanded(
                child: BottomNavbarItem(
                  isSelected: false,
                  icon: Icons.local_police,
                  text: 'One',
                ),
              ),
              Expanded(
                child: BottomNavbarItem(
                  isSelected: false,
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavbarItem extends StatelessWidget {
  final bool isSelected;
  final String text;
  final IconData icon;
  const BottomNavbarItem({super.key, required this.isSelected, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: isSelected == true ? tealBlue : bgGray3,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: isSelected == true ? tealBlue : bgGray3,
              ),
        )
      ],
    );
  }
}

class AnimatingCircles extends CustomPainter {
  final List<Animation<double>> ringAnimations;

  AnimatingCircles({
    required this.ringAnimations,
  }) : super(
          repaint: Listenable.merge([...ringAnimations]),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final canvasCenter = size.center(Offset.zero);

    final startRadius = size.width.floor() / 4;

    final minRadiusSpacing = ringAnimations.length;

    for (int i = 0; i < ringAnimations.length; i++) {
      final delta = getNthFibonnaci(startValue: minRadiusSpacing, n: i);

      var radius = startRadius +
          (i == 2
              ? (4 * minRadiusSpacing)
              : i > 0
                  ? (i * minRadiusSpacing)
                  : 0) +
          (i > 2 ? i * delta : 0);

      radius = lerpDouble(
        radius,
        radius * 1.1,
        Curves.fastOutSlowIn.transform(ringAnimations[i].value),
      )!;

      canvas.drawCircle(
        canvasCenter,
        radius,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.black.withOpacity(
            0.3 - (0.050 * i).clamp(0.0, 0.3),
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

int getNthFibonnaci({
  int startValue = 0,
  required n,
}) {
  assert(startValue >= 0);
  int num1 = 0;
  int num2 = startValue;
  int sum = 0;

  for (int i = 0; i < n; i++) {
    sum = num1 + num2;
    num1 = num2;
    num2 = sum;
  }

  return num2;
}
