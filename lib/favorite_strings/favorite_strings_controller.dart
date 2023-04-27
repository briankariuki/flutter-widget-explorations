import 'package:rxdart/rxdart.dart';

import 'domain/usecases/favorite_strings_use_case.dart';
import 'favorite_strings_page_state.dart';
import 'helpers/helpers.dart';
import 'models/models.dart';

class FavoriteStringsController extends DisposeCallbackBaseController {
  final Function() fetchFavoriteStrings;
  final Function(int value) setCurrentTab;
  final Function(FavoriteString value) favoriteString;

  final BehaviorSubject<int> currentTab$;

  final BehaviorSubject<List<FavoriteString>> favoriteStrings$;

  final BehaviorSubject<List<FavoriteString>> favoritedStrings$;

  final BehaviorSubject<FavoriteStringsMessage> message$;

  final Stream<bool> isFetching$;

  FavoriteStringsController._({
    required this.setCurrentTab,
    required this.fetchFavoriteStrings,
    required this.currentTab$,
    required this.isFetching$,
    required this.favoriteStrings$,
    required this.favoriteString,
    required this.message$,
    required this.favoritedStrings$,
    required Function0<void> dispose,
  }) : super(dispose);

  factory FavoriteStringsController(final FavoriteStringsUseCase favoriteStringsUseCase) {
    print('FavoriteStringsController initialized');

    final currentTabController = BehaviorSubject<int>.seeded(0);

    final isFetchingController = BehaviorSubject<bool>.seeded(false);

    final fetchFavoriteStringsController = PublishSubject<void>();

    final favoriteStringController = PublishSubject<FavoriteString>();

    final favoriteStringsController = BehaviorSubject<List<FavoriteString>>();

    final favoritedStringsController = BehaviorSubject<List<FavoriteString>>();

    final messageController = BehaviorSubject<FavoriteStringsMessage>();

    favoriteStringsUseCase.favoriteStringsState$().listen((e) {
      e.fold(
        ifLeft: (_) => {},
        ifRight: (state) {
          final _favoritedStrings = state.favoriteStrings!.toList();
          _favoritedStrings.sort((a, b) => a.id!.compareTo(b.id!));
          favoritedStringsController.add(_favoritedStrings);
        },
      );
    });

    favoriteStringController
        .throttle((event) => TimerStream(
              true,
              const Duration(seconds: 1),
            ))
        .listen((favoriteString) {
      favoriteStringsUseCase.favorite(favoriteString: favoriteString).listen((result) {
        result.fold(
            ifLeft: (_) => {},
            ifRight: (unit) {
              final _favoriteStrings = favoriteStringsController.value;

              final _index = _favoriteStrings.indexWhere((e) => e.id == unit.id);

              final _string = FavoriteString()
                ..id = unit.id
                ..title = unit.title
                ..favorited = !favoriteString.favorited;

              if (_index != -1) {
                _favoriteStrings[_index] = _string;
              }

              favoriteStringsController.add(_favoriteStrings);

              if (favoriteString.favorited) {
                messageController.add(FavoriteStringsFavoriteMessage(
                  'Favorite string removed',
                  MessageType.favorite,
                  _string,
                ));
              } else {
                messageController.add(const FavoriteStringsSuccessMessage(
                  'Favorite string saved',
                  MessageType.success,
                ));
              }
            });
      });
    });

    fetchFavoriteStringsController.listen((_) {
      favoriteStringsUseCase
          .listFavoriteStrings(limit: 8)
          .doOnListen(
            () => isFetchingController.add(true),
          )
          .doOnCancel(
            () => isFetchingController.add(false),
          )
          .listen(
        (result) {
          result.fold(
            ifLeft: (error) => {},
            ifRight: (_favoriteStrings) {
              if (favoritedStringsController.value.isNotEmpty) {
                for (int i = 0; i < _favoriteStrings.length; i++) {
                  final _string = _favoriteStrings[i];

                  final _favoritedStrings = favoritedStringsController.value;

                  final _index = _favoritedStrings.indexWhere((e) => e.id == _string.id);

                  if (_index != -1) {
                    _favoriteStrings[i] = FavoriteString()
                      ..id = _string.id
                      ..title = _string.title
                      ..favorited = true;
                  }
                }
              }
              favoriteStringsController.add(_favoriteStrings);
            },
          );
        },
      );
    });

    return FavoriteStringsController._(
      fetchFavoriteStrings: () => fetchFavoriteStringsController.add(null),
      currentTab$: currentTabController,
      setCurrentTab: (value) => currentTabController.add(value),
      isFetching$: isFetchingController,
      favoriteStrings$: favoriteStringsController,
      favoriteString: (value) => favoriteStringController.add(value),
      message$: messageController,
      favoritedStrings$: favoritedStringsController,
      dispose: () {
        currentTabController.drain();
        messageController.drain();
        isFetchingController.drain();
        favoriteStringsController.drain();
        favoritedStringsController.drain();

        currentTabController.close();
        messageController.close();
        favoriteStringsController.close();
        favoritedStringsController.close();

        print('FavoriteStringsController disposed');
      },
    );
  }
}
