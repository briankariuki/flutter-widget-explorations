// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuotePage _$QuotePageFromJson(Map<String, dynamic> json) => QuotePage()
  ..count = json['count'] as int?
  ..totalCount = json['totalCount'] as int?
  ..page = json['page'] as int?
  ..totalPages = json['totalPages'] as int?
  ..lastItemIndex = json['lastItemIndex'] as int?
  ..quotes = (json['results'] as List<dynamic>?)
      ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$QuotePageToJson(QuotePage instance) => <String, dynamic>{
      'count': instance.count,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'lastItemIndex': instance.lastItemIndex,
      'results': instance.quotes,
    };
