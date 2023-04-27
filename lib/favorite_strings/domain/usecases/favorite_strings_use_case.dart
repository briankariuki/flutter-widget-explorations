import 'package:dart_either/dart_either.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../repositories/favorite_strings_repository.dart';

class FavoriteStringsUseCase {
  final FavoriteStringsRepository _favoriteStringsRepository;

  const FavoriteStringsUseCase(this._favoriteStringsRepository);

  Stream<Result<List<FavoriteString>>> listFavoriteStrings({limit = 7}) => _favoriteStringsRepository.listFavoriteStrings(limit: limit);

  Stream<Either<AppError, FavoriteString>> favorite({
    FavoriteString? favoriteString,
  }) =>
      _favoriteStringsRepository.favorite(favoriteString: favoriteString);

  Stream<Either<AppError, FavoriteStringsState>> favoriteStringsState$() => _favoriteStringsRepository.favoriteStringsState$;
}
