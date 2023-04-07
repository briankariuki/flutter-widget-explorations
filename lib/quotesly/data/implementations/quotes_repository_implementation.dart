import 'package:dart_either/dart_either.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/quotes_repository.dart';
import '../../helpers/mappers.dart';
import '../../helpers/types.dart';
import '../../models/models.dart';
import '../exception/local_data_source_exception.dart';
import '../exception/remote_data_source_exception.dart';
import '../local/local_data_source.dart';
import '../remote/api/quotes_api.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  static const String tag = '[QUOTES_REPOSITORY]';

  final QuotesApi _quotesApi = QuotesApi();

  final LocalDataSource _localDataSource;

  @override
  final Stream<Result<QuotesState>> quotesState$;

  QuotesRepositoryImpl(this._localDataSource)
      : quotesState$ = _localDataSource.quotes$
            .map(
              (quotes) => quotes == null ? QuotesState(quotes = []) : QuotesState(quotes),
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
  ResponseResultStream listQuotes({
    String? tags,
    int limit = 10,
    int page = 1,
    int? maxLength,
    int? minLength,
    String? author,
    String? authorId,
    SortBy? sortBy,
    Order? order,
  }) {
    Map<String, dynamic> query = {'limit': limit, 'page': page};
    return _quotesApi.listQuotes(query).asStream().toEitherStream(
          Mappers.errorToAppError,
        );
  }

  @override
  ResponseResultStream listTags({SortBy? sortBy, Order? order}) {
    Map<String, dynamic> query = {};
    return _quotesApi.listTags(query).asStream().toEitherStream(
          Mappers.errorToAppError,
        );
  }

  @override
  ResponseResultStream randomQuote({
    String? tags,
    int? maxLength,
    int? minLength,
  }) {
    Map<String, dynamic> query = {};
    return _quotesApi.randomQuote(query).asStream().toEitherStream(
          Mappers.errorToAppError,
        );
  }

  @override
  ResponseResultStream randomQuotes({
    String? tags,
    int limit = 10,
    int? maxLength,
    int? minLength,
    String? author,
    String? authorId,
  }) {
    Map<String, dynamic> query = {
      'limit': 10,
    };
    return _quotesApi.randomQuotes(query).asStream().toEitherStream(
          Mappers.errorToAppError,
        );
  }

  Future<void> _init() async {
    print('$tag init');

    try {
      final localQuotes = await _localDataSource.quotes;

      if (localQuotes == null) {
        return;
      }
    } on RemoteDataSourceException catch (e) {
      print('$tag remote error=$e');
    } on LocalDataSourceException catch (e) {
      print('$tag local error=$e');
      await _localDataSource.removeQuotes();
    }
  }

  @override
  Stream<Either<AppError, Quote>> bookmarkQuote({Quote? quote}) {
    return _localDataSource.saveQuote(quote!).asStream().map((_) => quote).toEitherStream(Mappers.errorToAppError);
  }
}
