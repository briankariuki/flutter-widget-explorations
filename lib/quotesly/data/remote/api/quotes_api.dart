import 'package:dio/dio.dart';

import '../base_dio.dart';

class QuotesApi extends BaseDio {
  Future<Response<dynamic>> randomQuote(Map<String, dynamic> query) => get<dynamic>('random', queryParameters: query);

  Future<Response<dynamic>> randomQuotes(Map<String, dynamic> query) => get<dynamic>('quotes/random', queryParameters: query);

  Future<Response<dynamic>> listQuotes(Map<String, dynamic> query) => get<dynamic>('quotes', queryParameters: query);

  Future<Response<dynamic>> listTags(Map<String, dynamic> query) => get<dynamic>('tags', queryParameters: query);
}
