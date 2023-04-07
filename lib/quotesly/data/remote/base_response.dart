import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../models/models.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  Quote? quote;

  Error? error;

  QuotePage? quotePage;

  Tag? tag;

  TagPage? tagPage;

  static BaseResponse fromJson(dynamic json) => _$BaseResponseFromJson(json);

  static BaseResponse fromString(String json) => _$BaseResponseFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
