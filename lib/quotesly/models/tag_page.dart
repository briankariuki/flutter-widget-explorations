import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'tag.dart';

part 'tag_page.g.dart';

@JsonSerializable()
class TagPage {
  late int? count;

  @JsonKey(name: 'results')
  List<Tag>? tags;

  static TagPage fromJson(dynamic json) => _$TagPageFromJson(json);

  static TagPage fromString(String json) => _$TagPageFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$TagPageToJson(this);
}
