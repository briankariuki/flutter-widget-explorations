import 'dart:async';

import '../../models/models.dart';

abstract class LocalDataSource {
  /// Returns a subscription stream that emits [Quote] or null
  Stream<List<Quote>?> get quotes$;

  /// Returns a future that completes [Quote] or null
  Future<List<Quote>?> get quotes;

  /// Save [quote] into local storage.
  /// Throws [LocalDataSourceException] if saving is failed
  Future<void> saveQuote(Quote quote);

  /// Remove quote from local storage.
  /// Throws [LocalDataSourceException] if removing is failed
  Future<void> removeQuote(Quote quote);

  /// Remove all quotes from local storage.
  /// Throws [LocalDataSourceException] if removing is failed
  Future<void> removeQuotes();
}
