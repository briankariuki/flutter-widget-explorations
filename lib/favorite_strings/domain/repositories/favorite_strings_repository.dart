import '../../helpers/helpers.dart';
import 'package:dart_either/dart_either.dart';

import '../../models/models.dart';

abstract class FavoriteStringsRepository {
  Stream<Result<FavoriteStringsState>> get favoriteStringsState$;

  ///Get all favorite strings.
  Stream<Result<List<FavoriteString>>> listFavoriteStrings({
    int limit = 10,
  });

  ///Favorites a favoriteString and returns either a [FavoriteString] or [AppError]
  Stream<Either<AppError, FavoriteString>> favorite({FavoriteString? favoriteString});
}
