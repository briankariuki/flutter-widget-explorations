import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class Error {
  late String message;

  static Error fromJson(dynamic json) => _$ErrorFromJson(json);

  static Error fromString(String json) => _$ErrorFromJson(jsonDecode(json));

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
