import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/apple_bubble_ui/apple_bubble_ui_page.dart';
import 'package:flutter_reactive_programming/books_scroll/books_scroll_page.dart';
import 'package:flutter_reactive_programming/dynamic_tab_indicator/dynamic_tab_indicator_page.dart';
import 'package:flutter_reactive_programming/fancy_fab/fancy_fab_page.dart';
import 'package:flutter_reactive_programming/movie_cards/movie_cards_page.dart';
import 'package:flutter_reactive_programming/open_card/open_card_page.dart';
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
  PageRoute(
    routeName: FancyFabPage.routeName,
    title: 'Fancy Animated Fab',
    widget: const FancyFabPage(),
  ),
  PageRoute(
    routeName: OpenCardPage.routeName,
    title: 'Open Card',
    widget: const OpenCardPage(),
  ),
  PageRoute(
    routeName: AppleBubbleUIPage.routeName,
    title: 'Apple Watch Bubble UI',
    widget: const AppleBubbleUIPage(),
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
