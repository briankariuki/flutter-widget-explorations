import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  @JsonKey(name: '_id')
  late String? id;

  late String? name;

  static Tag fromJson(dynamic json) => _$TagFromJson(json);

  static Tag fromString(String json) => _$TagFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
