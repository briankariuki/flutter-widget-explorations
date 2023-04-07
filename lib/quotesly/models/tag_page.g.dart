// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagPage _$TagPageFromJson(Map<String, dynamic> json) => TagPage()
  ..count = json['count'] as int?
  ..tags = (json['results'] as List<dynamic>?)
      ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TagPageToJson(TagPage instance) => <String, dynamic>{
      'count': instance.count,
      'results': instance.tags,
    };
