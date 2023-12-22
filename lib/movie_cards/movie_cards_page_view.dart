import 'package:flutter/material.dart';

import 'package:flutter_widget_explorations/movie_cards/movie_cards_data.dart';

enum DragDirection { left, right, none }

class MovieCardsPageView extends StatefulWidget {
  final List<Movie> movies;

  final Function(Movie) onChangeSelectedMovie;

  const MovieCardsPageView({
    super.key,
    required this.movies,
    required this.onChangeSelectedMovie,
  });

  @override
  State<MovieCardsPageView> createState() => _MovieCardsPageViewState();
}

class _MovieCardsPageViewState extends State<MovieCardsPageView> {
  Offset dragStartPosition = Offset.zero;
  Offset dragPosition = Offset.zero;
  Offset mainCardDragOffset = Offset.zero;

  bool isDragging = false;

  DragDirection dragDirection = DragDirection.none;

  final maxDragOffset = 150.0;

  List<Movie> _movies = [];

  final curve = Curves.ease;
  final duration = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();

    _movies = [...widget.movies];
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Handle Drag Start
  void onDragStart(DragStartDetails details) {
    dragStartPosition = details.localPosition;
  }

  //Handle Drag Update
  void onDragUpdate(DragUpdateDetails details) {
    //Check if pan right or pan left
    if (details.localPosition.dx <= dragPosition.dx) {
      dragDirection = DragDirection.left;
    }

    if (details.localPosition.dx >= dragPosition.dx) {
      dragDirection = DragDirection.right;
    }

    var movedDistance = details.localPosition.dx - dragStartPosition.dx;
    var ratio = movedDistance.abs() / maxDragOffset;
    var factor = 1 / (ratio + 1);

    var updatedOffset = Offset(
      mainCardDragOffset.dx + (details.delta.dx * Curves.ease.transform(factor)),
      0,
    );

    //update focused card position

    setState(() {
      mainCardDragOffset = updatedOffset;
      dragPosition = details.localPosition;
      isDragging = true;
    });
  }

  //Handle Drag End
  void onDragEnd(DragEndDetails details) {
    final dragDistance = 0 - mainCardDragOffset.dx;

    if (dragDistance.abs() <= maxDragOffset * 0.8) {
      setState(() {
        mainCardDragOffset = Offset.zero;

        isDragging = false;
      });
    } else {
      final updatedMovies = updateArrangement(dragDirection, _movies);

      setState(() {
        mainCardDragOffset = Offset.zero;
        isDragging = false;
        _movies = updatedMovies;
      });

      widget.onChangeSelectedMovie(updatedMovies[2]);
    }
  }

  List<Movie> updateArrangement(DragDirection direction, List<Movie> movies) {
    if (direction == DragDirection.left) {
      List<Movie> _movies = [];

      _movies.insert(0, movies[1]);
      _movies.insert(1, movies[2]);

      _movies.insert(2, movies[3]);

      _movies.insert(3, movies[4]);

      _movies.insert(4, movies[0]);

      return _movies;
    } else {
      List<Movie> _movies = [];

      _movies.insert(0, movies[4]);
      _movies.insert(1, movies[0]);

      _movies.insert(2, movies[1]);

      _movies.insert(3, movies[2]);
      _movies.insert(4, movies[3]);

      return _movies;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (_, constraints) {
              List<Widget> _cards = [];

              List<Movie> moviesLeft = [];
              List<Movie> moviesCenter = [];
              List<Movie> moviesRight = [];

              for (int i = 0; i < _movies.length; i++) {
                if (i < 2) {
                  moviesLeft.add(_movies[i]);
                }

                if (i == 2) {
                  moviesCenter.add(_movies[i]);
                }

                if (i > 2) {
                  moviesRight.insert(0, _movies[i]);
                }
              }

              //For debug
              // print("Left ${moviesLeft.map((e) => e.title)}");
              // print("Right ${moviesRight.map((e) => e.title)}");
              // print("Center ${moviesCenter.map((e) => e.title)}");

              for (int i = 0; i < moviesLeft.length; i++) {
                var left = i == 0 ? -32.0 : 24.0;

                var scale = i == 0 ? 0.6 : 0.8;

                if (isDragging && dragDirection == DragDirection.left) {
                  if (i == 0) {
                    left = -32.0 + mainCardDragOffset.dx;
                  }

                  if (i == 1) {
                    left = 24.0 + mainCardDragOffset.dx;

                    scale = 0.8 + (-mainCardDragOffset.dx.abs() * 0.001);
                  }
                }
                final _widget = AnimatedPositioned(
                  duration: duration,
                  curve: curve,
                  left: left,
                  child: AnimatedScale(
                    duration: duration,
                    curve: curve,
                    scale: scale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: Stack(
                        children: [
                          Image.asset(
                            moviesLeft[i].image,
                            height: size.height / 2.5,
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: i == 0 ? 0.6 : 0.4,
                              child: Container(
                                color: const Color.fromARGB(255, 42, 42, 42),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );

                _cards.add(_widget);
              }

              for (int i = 0; i < moviesRight.length; i++) {
                var right = i == 0 ? -32.0 : 24.0;
                var scale = i == 0 ? 0.6 : 0.8;

                if (isDragging && dragDirection == DragDirection.right) {
                  if (i == 0) {
                    right = -32.0 - mainCardDragOffset.dx;
                  }

                  if (i == 1) {
                    right = 24.0 - mainCardDragOffset.dx;

                    scale = 0.8 + (-mainCardDragOffset.dx.abs() * 0.001);
                  }
                }
                final _widget = AnimatedPositioned(
                  duration: duration,
                  curve: curve,
                  right: right,
                  child: AnimatedScale(
                    duration: duration,
                    curve: curve,
                    scale: scale,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: Stack(
                            children: [
                              Image.asset(
                                moviesRight[i].image,
                                height: size.height / 2.5,
                              ),
                              Positioned.fill(
                                child: Opacity(
                                  opacity: i == 0 ? 0.6 : 0.4,
                                  child: Container(
                                    color: const Color.fromARGB(255, 42, 42, 42),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                _cards.add(_widget);
              }

              for (int i = 0; i < moviesCenter.length; i++) {
                var scale = 1.0 + (-mainCardDragOffset.dx.abs() * 0.005);

                var rotation = 0.0;

                if (isDragging && dragDirection == DragDirection.right) {
                  rotation = mainCardDragOffset.dx * 0.0005;
                }
                if (isDragging && dragDirection == DragDirection.left) {
                  rotation = mainCardDragOffset.dx * 0.0005;
                }

                final _widget = AnimatedPositioned(
                  duration: duration,
                  curve: curve,
                  right: 0.0,
                  left: 0.0,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) {
                      onDragStart(details);
                    },
                    onHorizontalDragUpdate: (details) {
                      onDragUpdate(details);
                    },
                    onHorizontalDragEnd: (details) {
                      onDragEnd(details);
                    },
                    child: Transform.translate(
                      offset: mainCardDragOffset,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 800),
                        curve: curve,
                        turns: rotation,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 800),
                          curve: curve,
                          scale: scale,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24.0),
                                child: Image.asset(
                                  moviesCenter[i].image,
                                  height: size.height / 2.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

                _cards.add(_widget);
              }
              return Stack(
                children: _cards,
              );
            },
          ),
        ),
        SizedBox(
          height: size.height / 2.5,
        ),
      ],
    );
  }
}
