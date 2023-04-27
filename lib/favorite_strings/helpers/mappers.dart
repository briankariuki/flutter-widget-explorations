import '../data/exception/local_data_source_exception.dart';
import '../models/models.dart';

abstract class Mappers {
  static AppError errorToAppError(Object e, StackTrace s) {
    if (e is LocalDataSourceException) {
      return AppError(
        message: e.message ?? 'Unknown Error',
        error: e,
        stackTrace: s,
      );
    }

    return AppError(
      message: e.toString(),
      error: e,
      stackTrace: s,
    );
  }
}
