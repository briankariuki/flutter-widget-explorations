import 'package:flutter/material.dart';
import 'package:flutter_widget_explorations/apple_bubble_ui/apple_bubble_ui_page.dart';
import 'package:flutter_widget_explorations/books_scroll/books_scroll_page.dart';
import 'package:flutter_widget_explorations/cart/cart_controller.dart';
import 'package:flutter_widget_explorations/dynamic_tab_indicator/dynamic_tab_indicator_page.dart';
import 'package:flutter_widget_explorations/fancy_edit_card/fancy_edit_card.dart';
import 'package:flutter_widget_explorations/favorite_strings/favorite_strings_page.dart';
import 'package:flutter_widget_explorations/fancy_fab/fancy_fab_page.dart';
import 'package:flutter_widget_explorations/metaball_shapes/metaball_shapes_page.dart';
import 'package:flutter_widget_explorations/movie_cards/movie_cards_page.dart';
import 'package:flutter_widget_explorations/open_card/open_card_page.dart';
import 'package:flutter_widget_explorations/quotesly/quotesly_page.dart';
import 'package:flutter_widget_explorations/surfshark/surfshark_page.dart';
import 'package:flutter_widget_explorations/who_to_follow/who_to_follow_widget.dart';
import 'package:provider/provider.dart';

import '../cart/cart_page.dart';

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
  PageRoute(
    routeName: SurfsharkPage.routeName,
    title: 'Surfshark',
    widget: const SurfsharkPage(),
  ),
  // PageRoute(
  //   routeName: FaceDetectionPage.routeName,
  //   title: 'FaceDetection',
  //   widget: const FaceDetectionPage(),
  //   isUnfinished: true,
  // ),
  PageRoute(
    routeName: QuoteslyPage.routeName,
    title: 'Quotesly',
    widget: const QuoteslyPage(),
    isUnfinished: false,
  ),

  PageRoute(
    routeName: CartPage.routeName,
    title: 'Cart',
    widget: Provider(
      create: (_) => CartController(),
      dispose: (_, cartController) => cartController.dispose(),
      child: const CartPage(),
    ),
    isUnfinished: false,
  ),

  PageRoute(
    routeName: FavoriteStringsPage.routeName,
    title: 'Favorite Strings',
    widget: const FavoriteStringsPage(),
    isUnfinished: false,
  ),
  PageRoute(
    routeName: MetaballShapesPage.routeName,
    title: 'Metaball Shapes',
    widget: const MetaballShapesPage(),
    isUnfinished: false,
  ),

  PageRoute(
    routeName: FancyEditCardPage.routeName,
    title: 'Fancy edit card',
    widget: const FancyEditCardPage(),
    isUnfinished: false,
  ),
];

class PageRoute {
  final String routeName;
  final String title;
  final bool isUnfinished;
  final Widget widget;

  PageRoute({
    required this.routeName,
    required this.title,
    required this.widget,
    this.isUnfinished = false,
  });
}
