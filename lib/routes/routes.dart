import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/movie_cards/movie_cards_page.dart';
import 'package:flutter_reactive_programming/who_to_follow/who_to_follow_widget.dart';

final routes = <PageRoute>[
  PageRoute(
    routeName: WhoToFollowWidget.routeName,
    title: 'Who To Follow',
    widget: const WhoToFollowWidget(),
  ),
  PageRoute(
    routeName: MovieCardsPage.routeName,
    title: 'Movie Cards',
    widget: const MovieCardsPage(),
  ),
];

class PageRoute {
  final String routeName;
  final String title;
  final Widget widget;

  PageRoute({
    required this.routeName,
    required this.title,
    required this.widget,
  });
}
