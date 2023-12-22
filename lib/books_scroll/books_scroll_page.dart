import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_explorations/books_scroll/books_scroll_data.dart';
import 'package:flutter_widget_explorations/util/image.dart';
import 'package:intl/intl.dart';

class BooksScrollPage extends StatefulWidget {
  static const String routeName = '/books-scroll';

  const BooksScrollPage({super.key});

  @override
  State<BooksScrollPage> createState() => _BooksScrollPageState();
}

class _BooksScrollPageState extends State<BooksScrollPage> {
  List<Book> _books = [];

  PageController pageController = PageController();

  double pagePercent = 0.0;
  int currentPage = 0;

  final itemSize = 72.0;

  @override
  void initState() {
    super.initState();

    _books = books;

    currentPage = 0;

    pageController = PageController(
      viewportFraction: 0.35,
    );

    pageController.addListener(scrollListener);
  }

  @override
  void dispose() {
    pageController
      ..removeListener(scrollListener)
      ..dispose();

    super.dispose();
  }

  void scrollListener() {
    currentPage = pageController.page!.floor();
    pagePercent = (pageController.page! - currentPage).abs();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Recommended books for you',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.04),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                    setState(() {
                      pagePercent = 0.0;
                    });
                  }
                  return false;
                },
                child: PageView.builder(
                  pageSnapping: false,
                  padEnds: false,
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: _books.length,
                  itemBuilder: (_, index) {
                    final book = _books[index];
                    return index == currentPage
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(
                                3,
                                2,
                                -0.001,
                              )
                              ..scale(lerpDouble(1.0, 0.4, (pagePercent / 3))!)
                              ..rotateX(lerpDouble(0, pi / 2, (pagePercent * 1.5))!)
                              ..translate(0.0, lerpDouble(0, (itemSize + 24) * 1.5, (pagePercent))!),
                            child: BookPanel(
                              book: book,
                            ),
                          )
                        : BookPanel(
                            book: book,
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookPanel extends StatelessWidget {
  final Book book;
  const BookPanel({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 72.0,
      padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
      child: Stack(
        children: [
          Positioned(
            right: 28.0,
            top: 0.0,
            bottom: 0.0,
            child: PhysicalModel(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(12.0),
              elevation: 16.0,
              color: Colors.transparent,
              shadowColor: Colors.black.withOpacity(0.8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black38,
                ),
                width: size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: NewtworkImageWrapper(
                    imageUrl: book.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            bottom: 16.0,
            left: 24.0,
            child: PhysicalModel(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(12.0),
              elevation: 16.0,
              color: Colors.transparent,
              shadowColor: Colors.black.withOpacity(0.8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                width: size.width / 2.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'By ${book.author}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            UserRating(
                              rating: book.rating,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            NumberFormat.compact().format(book.views),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'Views',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12.0,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserRating extends StatelessWidget {
  final double rating;
  const UserRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.0,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              Icons.star,
              color: index + 1 <= rating.floor() ? Colors.yellow : Colors.black26,
              size: 16.0,
            ),
          );
        },
      ),
    );
  }
}
