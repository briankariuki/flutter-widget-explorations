import 'package:dart_either/dart_either.dart';

import '../../helpers/types.dart';
import '../../models/models.dart';
import '../repositories/quotes_repository.dart';

class QuotesUseCase {
  final QuotesRepository _quotesRepository;

  const QuotesUseCase(this._quotesRepository);

  ResponseResultStream getRandomQuotes({
    String? tags,
    int limit = 10,
    int? maxLength,
    int? minLength,
    String? author,
    String? authorId,
  }) =>
      _quotesRepository.randomQuotes(
        tags: tags,
        limit: limit,
        maxLength: maxLength,
        minLength: minLength,
        author: author,
        authorId: authorId,
      );

  Stream<Either<AppError, Quote>> bookmarkQuote({
    Quote? quote,
  }) =>
      _quotesRepository.bookmarkQuote(quote: quote);

  Stream<Either<AppError, QuotesState>> quotesState$() => _quotesRepository.quotesState$;
}
