import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/movie_cards/movie_cards_page_view.dart';

import 'movie_cards_data.dart';

enum DragDirection { left, right, none }

class MovieCardsPage extends StatefulWidget {
  static const String routeName = '/movie-cards';
  const MovieCardsPage({super.key});

  @override
  State<MovieCardsPage> createState() => _MovieCardsPageState();
}

class _MovieCardsPageState extends State<MovieCardsPage> {
  Movie? selectedMovie;

  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();

    _movies = movies.sublist(0, movies.length - 1);

    selectedMovie = _movies[2];
  }

  void onChangeSelectedMovie(Movie movie) {
    setState(() {
      selectedMovie = movie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.6,
              child: Image.asset(
                selectedMovie!.image,
                fit: BoxFit.cover,
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
                    0.5,
                    0.9,
                  ],
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 30.0,
                sigmaY: 30.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MovieCardsPageView(
                      movies: _movies,
                      onChangeSelectedMovie: onChangeSelectedMovie,
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Align(
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
                            height: 12.0,
                          ),
                          Text(
                            selectedMovie!.category,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.white60,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
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
