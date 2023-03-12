import 'package:flutter/material.dart';

final List<PageTab> tabs = [
  PageTab(
    title: "3D Renders",
    imageUrl:
        "https://images.unsplash.com/photo-1678008583224-cd4f9582ef37?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1064&q=80",
  ),
  PageTab(
    title: "Wallpapers",
    imageUrl:
        "https://images.unsplash.com/photo-1678509651605-f2c0fa01c49a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
  ),
  PageTab(
    title: "Travel",
    imageUrl:
        "https://images.unsplash.com/photo-1678212915391-562e1e692b0a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1767&q=80",
  ),
  PageTab(
    title: "Nature",
    imageUrl:
        "https://images.unsplash.com/photo-1676839670988-55a7e968f5f2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDEyfDZzTVZqVExTa2VRfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
  ),
  PageTab(
    title: "Food & Drink",
    imageUrl:
        "https://images.unsplash.com/photo-1677523875173-e1f7f5138b40?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
  )
];

class PageTab {
  final String title;
  final String imageUrl;

  PageTab({required this.title, required this.imageUrl});

  Size getTabTextSize({
    TextStyle? style,
    double textScaleFactor = 1.0,
    TextDirection? textDirection,
  }) {
    final Size size = (TextPainter(
      text: TextSpan(text: title, style: style),
      maxLines: 1,
      textScaleFactor: textScaleFactor,
      textDirection: textDirection,
    )..layout())
        .size;

    return size;
  }
}
