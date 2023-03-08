import 'package:flutter_reactive_programming/assets.dart';

final List<Movie> movies = [
  Movie(
    title: 'Black Panther: Wakanda Forever',
    category: 'Action',
    image: Assets.wakandaforever,
  ),
  Movie(
    title: 'Knock at the Cabin',
    category: 'Thriller',
    image: Assets.knockatthecabin,
  ),
  Movie(
    title: 'Puss in Boots: The Last Wish',
    category: 'Animation',
    image: Assets.pussinboots,
  ),
  Movie(
    title: 'A Man Called Otto',
    category: 'Comedy',
    image: Assets.amancalledotto,
  ),
  Movie(
    title: 'Die Hart',
    category: 'Action',
    image: Assets.diehart,
  ),
  Movie(
    title: 'Plane',
    category: 'Action',
    image: Assets.plane,
  ),
];

class Movie {
  final String title;
  final String category;
  final String image;

  Movie({
    required this.title,
    required this.category,
    required this.image,
  });
}
