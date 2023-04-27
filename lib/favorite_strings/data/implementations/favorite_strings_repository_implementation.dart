import 'package:dart_either/dart_either.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/favorite_strings_repository.dart';
import '../../helpers/mappers.dart';
import '../../helpers/types.dart';
import '../../models/models.dart';
import '../exception/local_data_source_exception.dart';
import '../local/local_data_source.dart';

class FavoriteStringsRepositoryImpl implements FavoriteStringsRepository {
  static const String tag = '[FAVORITE_STRINGS_REPOSITORY]';

  final LocalDataSource _localDataSource;

  @override
  final Stream<Result<FavoriteStringsState>> favoriteStringsState$;

  FavoriteStringsRepositoryImpl(this._localDataSource)
      : favoriteStringsState$ = _localDataSource.favoriteStrings$
            .map(
              (favoriteStrings) => favoriteStrings == null ? FavoriteStringsState(favoriteStrings = []) : FavoriteStringsState(favoriteStrings),
            )
            .toEitherStream(Mappers.errorToAppError)
            .publishValue()
          ..listen(
            (state) => print('$tag state=$state'),
          )
          ..connect() {
    _init();
  }

  @override
  Stream<Result<List<FavoriteString>>> listFavoriteStrings({
    int limit = 10,
  }) {
    List<FavoriteString> _favoriteStrings = List.generate(
        limit,
        (index) => FavoriteString()
          ..favorited = false
          ..id = '${index + 1}'
          ..title = '${index + 1}');

    return Stream.value(_favoriteStrings).toEitherStream(
      Mappers.errorToAppError,
    );
  }

  Future<void> _init() async {
    print('$tag init');

    try {
      final localFavoriteStrings = await _localDataSource.favoriteStrings;

      if (localFavoriteStrings == null) {
        return;
      }
    } on LocalDataSourceException catch (e) {
      print('$tag local error=$e');
      await _localDataSource.removeFavoriteStrings();
    }
  }

  @override
  Stream<Either<AppError, FavoriteString>> favorite({FavoriteString? favoriteString}) {
    return (favoriteString?.favorited == false ? _localDataSource.saveFavoriteString(favoriteString!) : _localDataSource.removeFavoriteString(favoriteString!))
        .asStream()
        .map((_) => favoriteString)
        .toEitherStream(Mappers.errorToAppError);
  }
}
