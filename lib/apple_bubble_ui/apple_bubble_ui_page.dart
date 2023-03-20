import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/apple_bubble_ui/apple_bubble_ui_data.dart';

class AppleBubbleUIPage extends StatefulWidget {
  static const String routeName = '/apple-bubble-ui';
  const AppleBubbleUIPage({super.key});

  @override
  State<AppleBubbleUIPage> createState() => _AppleBubbleUIPageState();
}

class _AppleBubbleUIPageState extends State<AppleBubbleUIPage> {
  Offset dragOffset = Offset.zero;

  void onPanStart(DragStartDetails details) {}

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragOffset = dragOffset + details.delta;
    });
  }

  void onPanEnd(DragEndDetails details) {}

  List<Bubble> bubbles = [];

  List<List<Bubble>> chunks = [];

  double maxBubbleRadius = 24.0;
  double minBubbleRadius = 8.0;

  int bubbleRowItemCount = 5;

  double yRadius = 0.0;
  double xRadius = 0.0;
  double gutterWidth = 80.0;
  double cornerRadius = 24.0;

  @override
  void initState() {
    super.initState();

    bubbles = List.generate(
      150,
      (index) => Bubble(color: Colors.primaries[Random().nextInt(Colors.primaries.length)], assetName: ''),
    );

    //Calculate number of bubbles per row

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      setState(() {
        yRadius = (size.height / 1.8) / 2;

        xRadius = (size.width / 2.5) / 2;
      });

      var itemsFit = (size.width / ((maxBubbleRadius * 2) + 8.0)).floor();

      itemsFit = itemsFit;

      for (int i = 0; i < bubbles.length; i += itemsFit) {
        var end = (i + itemsFit) < bubbles.length ? i + itemsFit : bubbles.length;

        chunks.add(bubbles.sublist(i, end));
      }
    });
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
      body: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BubblesPainter(
                  bubbleChunks: chunks,
                  dragOffset: dragOffset,
                  maxBubbleRadius: maxBubbleRadius,
                  minBubbleRadius: minBubbleRadius,
                  cornerRadius: cornerRadius,
                  xRadius: xRadius,
                  yRadius: yRadius,
                  gutterWidth: gutterWidth,
                  debug: true,
                ),
                size: Size.infinite,
              ),
            ),

            // //Center region
            // Positioned(
            //   top: (size.height - (yRadius * 2) - gutterWidth) / 2,
            //   bottom: (size.height - (yRadius * 2) - gutterWidth) / 2,
            //   left: (size.width - (xRadius * 2) - gutterWidth) / 2,
            //   right: (size.width - (xRadius * 2) - gutterWidth) / 2,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(cornerRadius),
            //       color: Colors.white.withOpacity(0.3),
            //     ),
            //   ),
            // ),

            // Positioned(
            //   top: (size.height - (yRadius * 2)) / 2,
            //   bottom: (size.height - (yRadius * 2)) / 2,
            //   left: (size.width - (xRadius * 2)) / 2,
            //   right: (size.width - (xRadius * 2)) / 2,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(cornerRadius),
            //       color: Colors.white.withOpacity(0.4),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class BubblesPainter extends CustomPainter {
  final List<List<Bubble>> bubbleChunks;
  final Offset dragOffset;
  final double maxBubbleRadius;
  final double minBubbleRadius;
  final double xRadius;
  final double yRadius;
  final double cornerRadius;
  final double gutterWidth;
  final bool debug;

  BubblesPainter({
    required this.bubbleChunks,
    required this.dragOffset,
    required this.maxBubbleRadius,
    required this.minBubbleRadius,
    required this.xRadius,
    required this.yRadius,
    required this.cornerRadius,
    required this.gutterWidth,
    this.debug = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final canvasCenter = size.center(Offset.zero);

    final Rect cornerZone1 = Rect.fromLTRB(
      0.0,
      0.0,
      canvasCenter.dx - xRadius + cornerRadius,
      canvasCenter.dy - yRadius + cornerRadius,
    );

    final Rect cornerZone2 = Rect.fromLTRB(
      canvasCenter.dx + xRadius - cornerRadius,
      0.0,
      size.width,
      canvasCenter.dy - yRadius + cornerRadius,
    );

    final Rect cornerZone3 = Rect.fromLTRB(
      0.0,
      canvasCenter.dy + yRadius - cornerRadius,
      canvasCenter.dx - xRadius + cornerRadius,
      size.height,
    );

    final Rect cornerZone4 = Rect.fromLTRB(
      canvasCenter.dx + xRadius - cornerRadius,
      canvasCenter.dy + yRadius - cornerRadius,
      size.width,
      size.height,
    );

    final RRect centerZone = RRect.fromLTRBR(
      canvasCenter.dx - xRadius,
      canvasCenter.dy - yRadius,
      canvasCenter.dx + xRadius,
      canvasCenter.dy + yRadius,
      Radius.circular(cornerRadius),
    );

    final RRect fringeZone = RRect.fromLTRBR(
      canvasCenter.dx - xRadius - gutterWidth,
      canvasCenter.dy - yRadius - gutterWidth,
      canvasCenter.dx + xRadius + gutterWidth,
      canvasCenter.dy + yRadius + gutterWidth,
      Radius.circular(cornerRadius),
    );

    final Rect topMidZone = Rect.fromLTRB(
      canvasCenter.dx - xRadius + cornerRadius,
      canvasCenter.dy - yRadius - gutterWidth,
      canvasCenter.dx + xRadius - cornerRadius,
      canvasCenter.dy - yRadius,
    );

    final Rect bottomMidZone = Rect.fromLTRB(
      canvasCenter.dx - xRadius + cornerRadius,
      canvasCenter.dy + yRadius,
      canvasCenter.dx + xRadius - cornerRadius,
      canvasCenter.dy + yRadius + gutterWidth,
    );

    final Rect leftMidZone = Rect.fromLTRB(
      canvasCenter.dx - xRadius - gutterWidth,
      canvasCenter.dy - yRadius + cornerRadius,
      canvasCenter.dx - xRadius,
      canvasCenter.dy + yRadius - cornerRadius,
    );

    final Rect rightMidZone = Rect.fromLTRB(
      canvasCenter.dx + xRadius,
      canvasCenter.dy - yRadius + cornerRadius,
      canvasCenter.dx + xRadius + gutterWidth,
      canvasCenter.dy + yRadius - cornerRadius,
    );

    for (int i = 0; i < bubbleChunks.length; i++) {
      final drawOffset = i % 2 == 0 ? 0 : maxBubbleRadius;

      final bubbles = bubbleChunks[i];

      for (int j = 0; j < bubbles.length; j++) {
        Bubble bubble = bubbles[j];

        var xPosition = dragOffset.dx + drawOffset + (j * maxBubbleRadius * 2) + maxBubbleRadius + (j * 8.0);
        var yPosition = dragOffset.dy + 24.0 + i * maxBubbleRadius * 2;

        var bubblePosition = Offset(xPosition, yPosition);

        canvas.drawCircle(
          bubblePosition,
          getBubbleRadius(
            bubblePosition,
            bubble,
            canvasCenter,
            ((i * bubbles.length) + j),
            cornerZone1: cornerZone1,
            cornerZone2: cornerZone2,
            cornerZone3: cornerZone3,
            cornerZone4: cornerZone4,
            centerZone: centerZone,
            fringeZone: fringeZone,
            leftMidZone: leftMidZone,
            rightMidZone: rightMidZone,
            topMidZone: topMidZone,
            bottomMidZone: bottomMidZone,
          ),
          Paint()..color = bubble.color,
        );
      }
    }

    if (debug) {
      //Paint boundary rects

      canvas.drawRect(
        cornerZone1,
        Paint()..color = Colors.red.withOpacity(0.5),
      );

      canvas.drawRect(
        cornerZone2,
        Paint()..color = Colors.red.withOpacity(0.5),
      );

      canvas.drawRect(
        cornerZone3,
        Paint()..color = Colors.red.withOpacity(0.5),
      );

      canvas.drawRect(
        cornerZone4,
        Paint()..color = Colors.red.withOpacity(0.5),
      );

      canvas.drawRRect(
        centerZone,
        Paint()..color = Colors.blue.withOpacity(0.5),
      );
      canvas.drawRRect(
        fringeZone,
        Paint()..color = Colors.yellow.withOpacity(0.5),
      );
      canvas.drawRect(
        topMidZone,
        Paint()..color = Colors.green.withOpacity(0.5),
      );
      canvas.drawRect(
        bottomMidZone,
        Paint()..color = Colors.green.withOpacity(0.5),
      );
      canvas.drawRect(
        leftMidZone,
        Paint()..color = Colors.green.withOpacity(0.5),
      );
      canvas.drawRect(
        rightMidZone,
        Paint()..color = Colors.green.withOpacity(0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double getBubbleRadius(
    Offset bubblePosition,
    Bubble bubble,
    Offset canvasCenter,
    int index, {
    required Rect cornerZone1,
    required Rect cornerZone2,
    required Rect cornerZone3,
    required Rect cornerZone4,
    required RRect centerZone,
    required RRect fringeZone,
    required Rect topMidZone,
    required Rect bottomMidZone,
    required Rect leftMidZone,
    required Rect rightMidZone,
  }) {
    //Check if is in center region
    bool isInCenterZone = centerZone.contains(bubblePosition);

    //Check if is in fringe region
    bool isInFringeZone = fringeZone.contains(bubblePosition);

    // bool isInCornerZone1 = bubblePosition.dx.abs() < (canvasCenter.dx - xRadius + cornerRadius) && bubblePosition.dy < canvasCenter.dy - yRadius + cornerRadius;

    // bool isInCornerZone2 = bubblePosition.dx.abs() > (canvasCenter.dx + xRadius - cornerRadius) && bubblePosition.dy < canvasCenter.dy - yRadius + cornerRadius;

    // bool isInCornerZone3 = bubblePosition.dx.abs() < (canvasCenter.dx - xRadius + cornerRadius) && bubblePosition.dy > canvasCenter.dy + yRadius - cornerRadius;

    // bool isInCornerZone4 = bubblePosition.dx.abs() > (canvasCenter.dx + xRadius - cornerRadius) && bubblePosition.dy > canvasCenter.dy + yRadius - cornerRadius;

    bool isInCornerZone1 = cornerZone1.contains(bubblePosition);

    bool isInCornerZone2 = cornerZone2.contains(bubblePosition);

    bool isInCornerZone3 = cornerZone3.contains(bubblePosition);

    bool isInCornerZone4 = cornerZone4.contains(bubblePosition);

    if (isInCornerZone1 || isInCornerZone2 || isInCornerZone3 || isInCornerZone4) {
      // final distanceToCorner = getDistanceToPoint(
      //   bubblePosition,
      //   Offset(
      //     canvasCenter.dx - xRadius + cornerRadius,
      //     canvasCenter.dy - yRadius + cornerRadius,
      //   ),
      // );

      // if (distanceToCorner < (gutterWidth - cornerRadius)) {
      //   return 16.0;
      // }

      if (isInFringeZone) {
        final innerPointPosition = isInCornerZone1
            ? Offset(cornerZone1.right, cornerZone1.bottom)
            : isInCornerZone2
                ? Offset(cornerZone2.left, cornerZone2.bottom)
                : isInCornerZone3
                    ? Offset(cornerZone3.right, cornerZone3.top)
                    : Offset(cornerZone4.left, cornerZone4.top);

        final maxEndPointPosition = isInCornerZone1
            ? Offset(fringeZone.left, fringeZone.top)
            : isInCornerZone2
                ? Offset(fringeZone.right, fringeZone.top)
                : isInCornerZone3
                    ? Offset(fringeZone.left, fringeZone.bottom)
                    : Offset(fringeZone.right, fringeZone.bottom);

        final maxDistanceToCornerPoint = getDistanceToPoint(maxEndPointPosition, innerPointPosition);

        final distanceToInnerCornerPoint = getDistanceToPoint(bubblePosition, innerPointPosition);

        return lerpDouble(
          maxBubbleRadius,
          minBubbleRadius,
          (distanceToInnerCornerPoint / maxDistanceToCornerPoint),
        )!;
      }

      return minBubbleRadius;
    }

    if (isInCenterZone) {
      return maxBubbleRadius;
    }

    if (isInFringeZone) {
      if (topMidZone.contains(bubblePosition)) {
        return lerpDouble(
          minBubbleRadius,
          maxBubbleRadius,
          ((bubblePosition.dy - topMidZone.top).abs() / (topMidZone.bottom - topMidZone.top)),
        )!;
      }
      if (bottomMidZone.contains(bubblePosition)) {
        return lerpDouble(
          maxBubbleRadius,
          minBubbleRadius,
          ((bottomMidZone.top - bubblePosition.dy).abs() / (bottomMidZone.bottom - bottomMidZone.top)),
        )!;
      }
      if (leftMidZone.contains(bubblePosition)) {
        return lerpDouble(
          minBubbleRadius,
          maxBubbleRadius,
          ((leftMidZone.left - bubblePosition.dx).abs() / (leftMidZone.right - leftMidZone.left)),
        )!;
      }

      if (rightMidZone.contains(bubblePosition)) {
        return lerpDouble(
          maxBubbleRadius,
          minBubbleRadius,
          ((rightMidZone.left - bubblePosition.dx).abs() / (rightMidZone.right - rightMidZone.left)),
        )!;
      }
      return minBubbleRadius;
    }

    return minBubbleRadius;
  }

  double getDistanceToPoint(Offset startPosition, Offset endPosition) {
    return sqrt(
      pow((startPosition.dx - endPosition.dx).abs(), 2) + pow((startPosition.dy - endPosition.dy).abs(), 2),
    );
  }
}
