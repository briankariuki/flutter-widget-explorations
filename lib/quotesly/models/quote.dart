import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  @JsonKey(name: '_id')
  late String? id;

  late String? content;

  late String? author;

  late String? authorSlug;

  late int? length;

  late List<String>? tags;

  @JsonKey(defaultValue: false)
  late bool bookmarked;

  static Quote fromJson(dynamic json) => _$QuoteFromJson(json);

  static Quote fromString(String json) => _$QuoteFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}
