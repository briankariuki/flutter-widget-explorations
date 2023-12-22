import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_widget_explorations/movie_cards/movie_cards_page_view.dart';

import 'movie_cards_data.dart';

enum DragDirection { left, right, none }

class MovieCardsPage extends StatefulWidget {
  static const String routeName = '/movie-cards';
  const MovieCardsPage({super.key});

  @override
  State<MovieCardsPage> createState() => _MovieCardsPageState();
}

class _MovieCardsPageState extends State<MovieCardsPage> with SingleTickerProviderStateMixin {
  AnimationController? scaleController;
  Movie? selectedMovie;

  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _movies = movies.sublist(0, movies.length - 1);

    selectedMovie = _movies[2];

    scaleController?.forward();
  }

  @override
  void dispose() {
    scaleController?.dispose();
    super.dispose();
  }

  void onChangeSelectedMovie(Movie movie) {
    setState(() {
      selectedMovie = movie;
    });

    scaleController?.reset();

    scaleController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: scaleController!,
              builder: (context, child) {
                return Transform.scale(
                  scale: lerpDouble(
                    1.8,
                    1.6,
                    Curves.ease.transform(scaleController!.value),
                  ),
                  child: child,
                );
              },
              child: Image.asset(
                selectedMovie!.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 24.0,
                sigmaY: 24.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.1,
                    0.4,
                    0.8,
                  ],
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SafeArea(
                        child: MovieCardsPageView(
                          movies: _movies,
                          onChangeSelectedMovie: onChangeSelectedMovie,
                        ),
                      ),
                      Align(
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: scaleController!,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    0,
                                    lerpDouble(
                                      30,
                                      0,
                                      Curves.ease.transform(scaleController!.value),
                                    )!,
                                  ),
                                  child: child,
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    selectedMovie!.title,
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedBuilder(
                              animation: scaleController!,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: lerpDouble(
                                    0,
                                    1,
                                    Curves.ease.transform(scaleController!.value),
                                  )!,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      lerpDouble(
                                        56,
                                        0,
                                        Curves.ease.transform(scaleController!.value),
                                      )!,
                                    ),
                                    child: child,
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "${selectedMovie!.category} · ${selectedMovie!.duration}",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 16.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      selectedMovie!.overview,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            height: 1.61,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black26,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                height: 40.0,
                                width: 40.0,
                              ),
                              SizedBox(
                                height: 40.0 - 3,
                                width: 40.0 - 3,
                                child: AnimatedBuilder(
                                    animation: scaleController!,
                                    builder: (context, child) {
                                      return CircularProgressIndicator(
                                        value: lerpDouble(
                                          0,
                                          selectedMovie?.rating,
                                          Curves.ease.transform(scaleController!.value),
                                        )!,
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      );
                                    }),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${(selectedMovie!.rating * 100).toInt()}%',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 12.0,
                          ),
                          Text(
                            'User \nRating',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => {},
                        icon: const Icon(Icons.play_circle),
                        label: const Text('Watch Now'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          minimumSize: Size(size.width / 2, 48.0),
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 56.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
