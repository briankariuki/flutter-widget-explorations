import 'dart:async';

import '../../models/models.dart';

abstract class LocalDataSource {
  /// Returns a subscription stream that emits [FavoriteString] or null
  Stream<List<FavoriteString>?> get favoriteStrings$;

  /// Returns a future that completes [FavoriteString] or null
  Future<List<FavoriteString>?> get favoriteStrings;

  /// Save [favoriteString] into local storage.
  /// Throws [LocalDataSourceException] if saving is failed
  Future<void> saveFavoriteString(FavoriteString favoriteString);

  /// Remove favoriteString from local storage.
  /// Throws [LocalDataSourceException] if removing is failed
  Future<void> removeFavoriteString(FavoriteString favoriteString);

  /// Remove all favoriteStrings from local storage.
  /// Throws [LocalDataSourceException] if removing is failed
  Future<void> removeFavoriteStrings();
}
