import 'package:dio/dio.dart';

import '../data/exception/local_data_source_exception.dart';
import '../data/exception/remote_data_source_exception.dart';
import '../data/remote/base_response.dart';
import '../models/models.dart';

abstract class Mappers {
  static AppError errorToAppError(Object e, StackTrace s) {
    if (e is RemoteDataSourceException) {
      return AppError(
        message: e.message ?? 'Unknown Error',
        error: e,
        stackTrace: s,
      );
    }

    if (e is LocalDataSourceException) {
      return AppError(
        message: e.message ?? 'Unknown Error',
        error: e,
        stackTrace: s,
      );
    }

    if (e is DioError) {
      var message = '';

      switch (e.type) {
        case DioErrorType.connectionTimeout:
          message = 'Connection timeout. Try again';

          break;
        case DioErrorType.sendTimeout:
          message = 'Request took too long. Try again';
          break;
        case DioErrorType.receiveTimeout:
          message = 'Response took too long. Try again';
          break;
        case DioErrorType.badResponse:
          if (e.response?.data is BaseResponse) {
            message = '${(e.response?.data as BaseResponse).error?.message}';
          } else {
            message = 'Response error. Try again';
          }
          break;
        case DioErrorType.cancel:
          message = 'Request cancelled. Try again';
          break;
        default:
          message = 'An error occured. Try again';

          if (e.toString().contains('Network is unreachable') || e.toString().contains('Connection refused') || e.toString().contains('Http status error')) {
            message = 'Connection failed';
          }
          break;
      }

      return AppError(
        message: message,
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
