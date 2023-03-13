import 'package:flutter/material.dart';

final List<PageTab> tabs = [
  PageTab(
    title: "3D Renders",
    imageUrl:
        "https://images.unsplash.com/photo-1678008583224-cd4f9582ef37?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1064&q=80",
    description:
        "The Unsplash community continues to push the boundaries of creativity through 3D Renders. From abstract worlds to photo-realistic interiors, this category celebrates exciting 3-dimensional images designed in the software of your choice and rendered into JPEG images.",
  ),
  PageTab(
    title: "Wallpapers",
    imageUrl:
        "https://images.unsplash.com/photo-1678509651605-f2c0fa01c49a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1674&q=80",
    description: "From epic drone shots to inspiring moments in nature — submit your best desktop and mobile backgrounds.",
  ),
  PageTab(
    title: "Travel",
    imageUrl:
        "https://images.unsplash.com/photo-1678212915391-562e1e692b0a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1767&q=80",
    description: "Discover hidden wonders and inspiring destinations around the world from the comfort of your own home.",
  ),
  PageTab(
    title: "Nature",
    imageUrl:
        "https://images.unsplash.com/photo-1676839670988-55a7e968f5f2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDEyfDZzTVZqVExTa2VRfHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60",
    description:
        "Through photography, the beauty of Mother Nature can be frozen in time. This category celebrates the magic of our planet and beyond — from the immensity of the great outdoors, to miraculous moments in your own backyard.",
  ),
  PageTab(
    title: "Food & Drink",
    imageUrl:
        "https://images.unsplash.com/photo-1677523875173-e1f7f5138b40?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    description:
        "From simple home-cooked dinners at home, to tasting new dishes while traveling — food connects us all. This category examines the world of food photography, with shots of everything from summer picnics in the park to decadent deserts.",
  )
];

class PageTab {
  final String title;
  final String imageUrl;
  final String description;

  PageTab({
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  Size getTabTextSize({
    TextStyle? style,
    double textScaleFactor = 1.0,
    TextDirection textDirection = TextDirection.ltr,
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
