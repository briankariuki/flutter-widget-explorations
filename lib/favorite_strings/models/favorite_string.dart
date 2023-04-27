import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'favorite_string.g.dart';

@JsonSerializable()
class FavoriteString {
  @JsonKey(name: '_id')
  late String? id;

  late String? title;

  @JsonKey(defaultValue: false)
  late bool favorited;

  static FavoriteString fromJson(dynamic json) => _$FavoriteStringFromJson(json);

  static FavoriteString fromString(String json) => _$FavoriteStringFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$FavoriteStringToJson(this);
}
