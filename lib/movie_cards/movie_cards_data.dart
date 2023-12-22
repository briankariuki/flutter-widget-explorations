import 'package:flutter_widget_explorations/assets.dart';

final List<Movie> movies = [
  Movie(
    title: 'Black Panther: Wakanda Forever',
    category: 'Action',
    image: Assets.wakandaforever,
    overview:
        'Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death. As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda.',
    rating: 0.73,
    duration: '2h 42m',
  ),
  Movie(
    title: 'Knock at the Cabin',
    category: 'Thriller',
    image: Assets.knockatthecabin,
    overview:
        'While vacationing at a remote cabin, a young girl and her two fathers are taken hostage by four armed strangers who demand that the family make an unthinkable choice to avert the apocalypse. With limited access to the outside world, the family must decide what they believe before all is lost.',
    rating: 0.65,
    duration: '1h 40m',
  ),
  Movie(
    title: 'Puss in Boots: The Last Wish',
    category: 'Animation',
    image: Assets.pussinboots,
    overview:
        'Puss in Boots discovers that his passion for adventure has taken its toll: He has burned through eight of his nine lives, leaving him with only one life left. Puss sets out on an epic journey to find the mythical Last Wish and restore his nine lives.',
    rating: 0.84,
    duration: '1h 43m',
  ),
  Movie(
    title: 'A Man Called Otto',
    category: 'Comedy',
    image: Assets.amancalledotto,
    overview:
        'When a lively young family moves in next door, grumpy widower Otto Anderson meets his match in a quick-witted, pregnant woman named Marisol, leading to an unlikely friendship that turns his world upside down.',
    rating: 0.79,
    duration: '2h 6m',
  ),
  Movie(
    title: 'Die Hart',
    category: 'Action',
    image: Assets.diehart,
    overview:
        'Follows a fictionalized version of Kevin Hart, as he tries to become an action movie star. He attends a school run by Ron Wilcox, where he attempts to learn the ropes on how to become one of the industry\'s most coveted action stars.',
    rating: 0.63,
    duration: '1h 25m',
  ),
  Movie(
    title: 'Plane',
    category: 'Action',
    image: Assets.plane,
    overview:
        'After a heroic job of successfully landing his storm-damaged aircraft in a war zone, a fearless pilot finds himself between the agendas of multiple militias planning to take the plane and its passengers hostage.',
    rating: 0.68,
    duration: '1h 47m',
  ),
];

class Movie {
  final String title;
  final String category;
  final String image;
  final String overview;
  final double rating;
  final String duration;

  Movie({
    required this.title,
    required this.category,
    required this.image,
    required this.overview,
    this.rating = 0.5,
    required this.duration,
  });
}
