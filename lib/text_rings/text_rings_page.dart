import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class TextRingsPage extends StatefulWidget {
  static const String routeName = '/text-rings';

  const TextRingsPage({super.key});

  @override
  State<TextRingsPage> createState() => _TextRingsPageState();
}

class _TextRingsPageState extends State<TextRingsPage> with SingleTickerProviderStateMixin {
  final List<Ring> rings = [];
  final random = Random();

  final elapsedTime = ValueNotifier<double>(0.0);

  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick);
    _ticker.start();

    final durationRandom = SnappingRandom<double>(min: 5.0, max: 20.0, increment: 0.2);
    final delayRandom = SnappingRandom<double>(min: -5.0, max: -1, increment: 0.1);

    for (var i = 0; i < 100; i++) {
      rings.add(
        Ring(
            id: i,
            hue: random.nextInt(359),
            spread: random.nextInt(359 - 75) + 75,
            angle: 0.0,
            duration: durationRandom.nextValue(),
            delay: delayRandom.nextValue()),
      );
    }
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration duration) {
    elapsedTime.value = duration.inMilliseconds / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 60.0,
        );
    final textSize = getTextSize(text: "transitions.", style: textStyle);

    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "all about them",
              textAlign: TextAlign.left,
              style: textStyle,
            ),
            // Text("transitions.", textAlign: TextAlign.left, style: textStyle),
            ValueListenableBuilder<double>(
                valueListenable: elapsedTime,
                builder: (context, value, _child) {
                  return CustomPaint(
                    foregroundPainter: TextRingsPainter(
                      elapsedTime: value,
                      dpi: MediaQuery.of(context).devicePixelRatio,
                      rings: rings,
                      textPainter: TextPainter(
                        text: TextSpan(text: "transitions.", style: textStyle),
                        maxLines: 1,
                        textScaleFactor: 1.0,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    size: textSize,
                  );
                })
          ],
        ),
      ),
    );
  }

  Size getTextSize({
    required String text,
    TextStyle? style,
    double textScaleFactor = 1.0,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    final Size size = (TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: textScaleFactor,
      textDirection: textDirection,
    )..layout())
        .size;

    return size;
  }
}

class TextRingsPainter extends CustomPainter {
  final double elapsedTime;
  final TextPainter textPainter;
  final List<Ring> rings;
  final double dpi;

  TextRingsPainter({
    required this.textPainter,
    required this.rings,
    required this.dpi,
    required this.elapsedTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;

    //Clip the canvas drawing area to the size of the text
    canvas.clipRect(rect);

    canvas.drawRect(rect, Paint()..color = const HSLColor.fromAHSL(1.0, 210, 0.29, 0.33).toColor());

    for (Ring ring in rings) {
      final rotate = (ring.angle * pi) / 180;
      final startAngle = 0 - (elapsedTime * ring.duration) / ring.delay;
      final endAngle = ((ring.spread * pi) / 180) + (elapsedTime / (ring.duration * ring.delay * pi));

      canvas.rotate(rotate);

      canvas.drawArc(
        Rect.fromCircle(center: size.topCenter(Offset(0, -1 * dpi)), radius: ring.id * 2 * dpi),
        startAngle,
        endAngle,
        false,
        Paint()
          ..strokeWidth = 1.0 * dpi
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..color = HSLColor.fromAHSL(1.0, ring.hue.toDouble(), 0.6, 0.5).toColor(),
      );
    }

    //Save canvas parent/destination layer.
    //Use [BlendMode.dstIn] to clip to source text
    canvas.saveLayer(rect, Paint()..blendMode = BlendMode.dstIn);

    //Draw source layer
    textPainter
      ..layout()
      ..paint(canvas, Offset.zero);

    //Restore destination/parent layer
    //Clipped to where the source layer is visible
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Ring {
  final int id;
  final int hue;
  final int spread;
  final double angle;
  final double duration;
  final double delay;

  Ring({
    required this.id,
    required this.hue,
    required this.spread,
    required this.angle,
    required this.delay,
    required this.duration,
  });
}

//Generated by ChatGPT. Use with caution 💀
class SnappingRandom<T extends num> {
  final T min;
  final T max;
  final T increment;

  SnappingRandom({required this.min, required this.max, required this.increment});

  T nextValue() {
    if (min > max || increment <= 0) {
      throw ArgumentError("Invalid range or increment");
    }

    final random = Random();
    final range = (max - min) / increment;
    final snappedRange = (range).floor();
    final snappedValue = (random.nextInt(snappedRange + 1) * increment + min) as T;

    return snappedValue.clamp(min, max) as T;
  }
}
