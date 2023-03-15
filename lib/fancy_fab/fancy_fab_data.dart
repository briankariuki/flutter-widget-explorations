import 'package:flutter/material.dart';

final icons = <FabIcon>[
  FabIcon(
    color: const Color.fromRGBO(252, 84, 81, 1),
    icon: const Icon(
      Icons.movie,
      color: Colors.black,
    ),
  ),
  FabIcon(
    color: const Color.fromRGBO(255, 209, 50, 1),
    icon: const Icon(
      Icons.calendar_month,
      color: Colors.black,
    ),
  ),
  FabIcon(
    color: const Color.fromRGBO(49, 200, 89, 1),
    icon: const Icon(
      Icons.photo_camera,
      color: Colors.black,
    ),
  ),
  FabIcon(
    color: const Color.fromRGBO(39, 202, 254, 1),
    icon: const Icon(
      Icons.format_quote_sharp,
      color: Colors.black,
    ),
  ),
  FabIcon(
    color: const Color.fromRGBO(252, 113, 253, 1),
    icon: const Icon(
      Icons.mic,
      color: Colors.black,
    ),
  ),
  FabIcon(
    color: const Color.fromARGB(255, 255, 255, 255),
    icon: const Icon(
      Icons.close,
      color: Colors.black,
    ),
  ),
];

class FabIcon {
  final Color color;
  final Icon icon;

  FabIcon({
    required this.color,
    required this.icon,
  });
}
