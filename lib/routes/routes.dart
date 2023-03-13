import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/books_scroll/books_scroll_page.dart';
import 'package:flutter_reactive_programming/dynamic_tab_indicator/dynamic_tab_indicator_page.dart';
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
  PageRoute(
    routeName: BooksScrollPage.routeName,
    title: 'Books Scroll',
    widget: const BooksScrollPage(),
  ),
  PageRoute(
    routeName: DynamicTabIndicatorPage.routeName,
    title: 'Dynamic Tab Indicator',
    widget: const DynamicTabIndicatorPage(),
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
