import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MetaballShapesPage extends StatefulWidget {
  static const String routeName = '/metaball-shapes';
  const MetaballShapesPage({super.key});

  @override
  State<MetaballShapesPage> createState() => _MetaballShapesPageState();
}

class _MetaballShapesPageState extends State<MetaballShapesPage> {
  List<MetaballCircle> circles = [];

  final GlobalObjectKey key = const GlobalObjectKey('painterkey');

  Offset dragPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    circles = [
      MetaballCircle(
        position: const Offset(20.0, 0.0),
        radius: 80.0,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      MetaballCircle(
        position: const Offset(0.0, -240.0),
        radius: 80.0,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      MetaballCircle(
        position: const Offset(-60.0, 240.0),
        radius: 80.0,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
    ];
  }

  void onPanStart(DragStartDetails details) {
    final obj = key.currentContext?.findRenderObject() as RenderBox;

    final canvasSize = obj.size;
    setState(() {
      dragPosition = details.globalPosition;
    });

    List<MetaballCircle> newCircles = [];

    for (var circle in circles) {
      bool _tapped = circle.isTapped(canvasSize, dragPosition);

      newCircles.add(
        MetaballCircle(
          position: circle.position,
          radius: circle.radius,
          color: circle.color,
          isSelected: _tapped,
        ),
      );
    }

    setState(() {
      circles = newCircles;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
    });

    List<MetaballCircle> newCircles = [];

    for (var circle in circles) {
      newCircles.add(
        MetaballCircle(
          position: circle.position + (circle.isSelected ? details.delta : Offset.zero),
          radius: circle.radius,
          isSelected: circle.isSelected,
          color: circle.color,
        ),
      );
    }

    setState(() {
      circles = newCircles;
    });
  }

  void onPanEnd(DragEndDetails details) {
    List<MetaballCircle> newCircles = [];

    for (var circle in circles) {
      newCircles.add(
        MetaballCircle(
          position: circle.position,
          radius: circle.radius,
          isSelected: false,
          color: circle.color,
        ),
      );
    }

    setState(() {
      circles = newCircles;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: ColorFiltered(
        colorFilter: const ColorFilter.matrix(
          <double>[
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            60,
            -6000,
          ],
        ),
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: CustomPaint(
            key: key,
            painter: MetaballShapesPainter(
              circles: circles,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class MetaballShapesPainter extends CustomPainter {
  final List<MetaballCircle> circles;

  MetaballShapesPainter({
    required this.circles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      canvas.drawCircle(
        size.center(circle.position),
        circle.radius,
        Paint()
          ..color = circle.color
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            30.0,
          ),

        //Works too
        // ..imageFilter = ImageFilter.blur(
        //   sigmaX: 30.0,
        //   sigmaY: 30.0,
        //   tileMode: TileMode.decal,
        // ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MetaballCircle {
  final Offset position;
  final double radius;
  final bool isSelected;
  final Color color;

  const MetaballCircle({
    required this.position,
    required this.radius,
    this.isSelected = false,
    this.color = Colors.red,
  });

  bool isTapped(Size canvasSize, Offset tappedPosition) {
    return Rect.fromCircle(center: canvasSize.center(position), radius: radius).contains(tappedPosition);
  }
}
