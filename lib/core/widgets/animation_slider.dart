import 'dart:ui';

import 'package:flutter/material.dart';

class AnimationSlider extends StatelessWidget {
  final AnimationController controller;
  final Function(double) onChanged;
  const AnimationSlider({super.key, required this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Column(
            children: [
              Slider(
                value: controller.value,
                // onChanged: (value) {
                //   controller.value = value;
                // },
                onChanged: onChanged,
              ),
              Text(
                Duration(
                  milliseconds: lerpDouble(0, controller.duration!.inMilliseconds.toDouble(), controller.value)!.floor(),
                ).toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
