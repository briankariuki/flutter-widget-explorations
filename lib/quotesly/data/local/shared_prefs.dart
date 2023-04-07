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
  Future<void> removeQuotes() => _prefs.remove(kQuotes).onError(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot delete quotes from local storage',
          error,
          stackTrace,
        ),
      );

  @override
  Future<void> saveQuote(Quote quote) async {
    List<String>? _quotes = [];

    _quotes = await _prefs.getStringList(kQuotes).onError(
              (error, stackTrace) => throw LocalDataSourceException(
                'Cannot get quotes from local storage',
                error,
                stackTrace,
              ),
            ) ??
        [];

    _quotes = [..._quotes, quote.toString()];

    return _prefs
        .setStringList(
          kQuotes,
          _quotes,
        )
        .onError(
          (error, stackTrace) => throw LocalDataSourceException(
            'Cannot save quotes to local storage',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Future<void> removeQuote(Quote quote) async {
    List<String>? _quotes = [];

    _quotes = await _prefs.getStringList(kQuotes).onError(
              (error, stackTrace) => throw LocalDataSourceException(
                'Cannot get quotes from local storage',
                error,
                stackTrace,
              ),
            ) ??
        [];

    _quotes.removeWhere((e) => e == quote.toString());

    return _prefs
        .setStringList(
          kQuotes,
          _quotes,
        )
        .onError(
          (error, stackTrace) => throw LocalDataSourceException(
            'Cannot save quotes to local storage',
            error,
            stackTrace,
          ),
        );
  }

  @override
  Future<List<Quote>?> get quotes => _prefs
      .read<List<Quote>>(
        kQuotes,
        (dynamic value) => value == null
            ? value
            : (value as List<dynamic>)
                .map((e) => Quote.fromJson(
                      jsonDecode(e),
                    ))
                .toList(),
      )
      .onError(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot save quotes to local storage',
          error,
          stackTrace,
        ),
      );

  @override
  Stream<List<Quote>?> get quotes$ => _prefs
      .observe<List<Quote>>(
        kQuotes,
        (dynamic value) => value == null
            ? value
            : (value as List<dynamic>)
                .map((e) => Quote.fromJson(
                      jsonDecode(e),
                    ))
                .toList(),
      )
      .onErrorReturnWith(
        (error, stackTrace) => throw LocalDataSourceException(
          'Cannot save quotes to local storage',
          error,
          stackTrace,
        ),
      );
}
