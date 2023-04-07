import 'package:dart_either/dart_either.dart';

import '../../helpers/types.dart';
import '../../models/models.dart';

enum SortBy {
  dateAdded,
  dateModified,
  author,
  content,
}

enum Order {
  asc,
  desc,
}

abstract class QuotesRepository {
  Stream<Result<QuotesState>> get quotesState$;

  ResponseResultStream randomQuote({
    String? tags,
    int? maxLength,
    int? minLength,
  });

  ResponseResultStream randomQuotes({
    String? tags,
    int limit = 10,
    int? maxLength,
    int? minLength,
    String? author,
    String? authorId,
  });

  //Get all quotes matching a given query. By default, this will return a paginated list of all quotes, sorted by _id. Quotes can also be filter by author, tag, and length.
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
  });

  //Get a list of all tags
  ResponseResultStream listTags({
    SortBy? sortBy,
    Order? order,
  });

  Stream<Either<AppError, Quote>> bookmarkQuote({Quote? quote});
}
