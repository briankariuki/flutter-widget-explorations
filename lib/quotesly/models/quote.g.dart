// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote()
  ..id = json['_id'] as String?
  ..content = json['content'] as String?
  ..author = json['author'] as String?
  ..authorSlug = json['authorSlug'] as String?
  ..length = json['length'] as int?
  ..tags = (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..bookmarked = json['bookmarked'] as bool? ?? false;

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'authorSlug': instance.authorSlug,
      'length': instance.length,
      'tags': instance.tags,
      'bookmarked': instance.bookmarked,
    };
