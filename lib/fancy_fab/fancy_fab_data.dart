import 'package:flutter/material.dart';

final icons = <FabIcon>[
  FabIcon(
    color: const Color.fromRGBO(252, 84, 81, 1),
    icon: const Icon(Icons.movie),
    size: const Size.fromRadius(16.0),
  ),
];

class FabIcon {
  final Color color;
  final Icon icon;
  final Size size;

  FabIcon({
    required this.color,
    required this.icon,
    required this.size,
  });
}
