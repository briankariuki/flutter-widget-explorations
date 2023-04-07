import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'quote.dart';

part 'quote_page.g.dart';

@JsonSerializable()
class QuotePage {
  late int? count;

  late int? totalCount;

  late int? page;

  late int? totalPages;

  late int? lastItemIndex;

  @JsonKey(name: 'results')
  late List<Quote>? quotes;

  static QuotePage fromJson(dynamic json) => _$QuotePageFromJson(json);

  static QuotePage fromString(String json) => _$QuotePageFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$QuotePageToJson(this);
}
