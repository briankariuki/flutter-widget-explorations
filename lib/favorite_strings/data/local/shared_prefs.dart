import 'dart:async';
import 'dart:convert';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

import '../../config/key.dart';
import '../../models/models.dart';
import '../exception/local_data_source_exception.dart';
import 'local_data_source.dart';

class SharedPrefs implements LocalDataSource {
  final RxSharedPreferences _prefs;

  const SharedPrefs(this._prefs);

  @override
  Future<void> removeFavoriteStrings() => _prefs.remove(kFavoriteStrings).onError(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot delete favoriteStrings from local storage',
          error,
          stackTrace,
        ),
      );

  @override
  Future<void> saveFavoriteString(FavoriteString favoriteString) async {
    List<String>? _favoriteStrings = [];

    _favoriteStrings = await _prefs.getStringList(kFavoriteStrings).onError(
              (error, stackTrace) => throw LocalDataSourceException(
                'Cannot get favoriteStrings from local storage',
                error,
                stackTrace,
              ),
            ) ??
        [];

    var _favoriteString = FavoriteString()
      ..favorited = true
      ..title = favoriteString.title
      ..id = favoriteString.id;

    _favoriteStrings = [
      _favoriteString.toString(),
      ..._favoriteStrings,
    ];

    _prefs
        .setStringList(
          kFavoriteStrings,
          _favoriteStrings,
        )
        .onError(
          (error, stackTrace) => throw LocalDataSourceException(
            'Cannot save favoriteStrings to local storage',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Future<void> removeFavoriteString(FavoriteString favoriteString) async {
    List<String>? _favoriteStrings = [];

    _favoriteStrings = await _prefs.getStringList(kFavoriteStrings).onError(
              (error, stackTrace) => throw LocalDataSourceException(
                'Cannot get favoriteStrings from local storage',
                error,
                stackTrace,
              ),
            ) ??
        [];

    _favoriteStrings.removeWhere((e) => e == favoriteString.toString());

    _prefs
        .setStringList(
          kFavoriteStrings,
          _favoriteStrings,
        )
        .onError(
          (error, stackTrace) => throw LocalDataSourceException(
            'Cannot save favoriteStrings to local storage',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Future<List<FavoriteString>?> get favoriteStrings => _prefs
      .read<List<FavoriteString>>(
        kFavoriteStrings,
        _toListFavoriteString,
      )
      .onError(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot get favoriteStrings from local storage',
          error,
          stackTrace,
        ),
      );

  @override
  Stream<List<FavoriteString>?> get favoriteStrings$ => _prefs
      .getStringListStream(kFavoriteStrings)
      .map(
        _toListFavoriteString,
      )
      .onErrorReturnWith(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot read favoriteStrings stream from local storage',
          error,
          stackTrace,
        ),
      );

  List<FavoriteString>? _toListFavoriteString(dynamic value) {
    return value == null
        ? null
        : (value as List<dynamic>)
            .map((e) => FavoriteString.fromJson(
                  jsonDecode(e),
                ))
            .toList();
  }
}
