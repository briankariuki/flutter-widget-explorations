import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/util/image.dart';

class BooksScrollPage extends StatefulWidget {
  static const String routeName = '/books-scroll';

  const BooksScrollPage({super.key});

  @override
  State<BooksScrollPage> createState() => _BooksScrollPageState();
}

class _BooksScrollPageState extends State<BooksScrollPage> {
  List<dynamic> books = [];

  PageController pageController = PageController();

  double pagePercent = 0.0;
  int currentPage = 0;

  final itemSize = 72.0;

  @override
  void initState() {
    super.initState();

    books = List.generate(
      15,
      (index) => Container(),
    );

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

    // print(currentPage);
    // print(pagePercent);
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
            child: Text(
              'Books',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Expanded(
            child: Container(
              color: Colors.red[100],
              child: PageView.builder(
                pageSnapping: false,
                padEnds: false,
                controller: pageController,
                scrollDirection: Axis.vertical,
                itemCount: books.length,
                itemBuilder: (_, index) {
                  return index == currentPage
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(
                              3,
                              2,
                              -0.001,
                            )
                            ..scale(lerpDouble(1.0, 0.8, (pagePercent / 2))!)
                            ..rotateX(lerpDouble(0, pi / 2, (pagePercent * 2))!)
                            ..translate(0.0, lerpDouble(0, (itemSize + 24) * 1.8, (pagePercent))!),
                          child: const BookPanel(),
                        )
                      : const BookPanel();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookPanel extends StatelessWidget {
  const BookPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
      child: Stack(
        children: [
          Positioned(
            right: 28.0,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.red,
              ),
              width: size.width / 2.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: const NewtworkImageWrapper(
                  imageUrl: 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1529358577i/39939417.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            bottom: 16.0,
            left: 24.0,
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(12.0),
              elevation: 20.0,
              color: Colors.black.withOpacity(0.3),
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
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Five Feet Apart',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'By Rachel',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
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
                            '2,781',
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
