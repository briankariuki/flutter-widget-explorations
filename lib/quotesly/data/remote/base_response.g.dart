// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..quote = json['quote'] == null
      ? null
      : Quote.fromJson(json['quote'] as Map<String, dynamic>)
  ..error = json['error'] == null
      ? null
      : Error.fromJson(json['error'] as Map<String, dynamic>)
  ..quotePage = json['quotePage'] == null
      ? null
      : QuotePage.fromJson(json['quotePage'] as Map<String, dynamic>)
  ..tag = json['tag'] == null
      ? null
      : Tag.fromJson(json['tag'] as Map<String, dynamic>)
  ..tagPage = json['tagPage'] == null
      ? null
      : TagPage.fromJson(json['tagPage'] as Map<String, dynamic>);

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'quote': instance.quote,
      'error': instance.error,
      'quotePage': instance.quotePage,
      'tag': instance.tag,
      'tagPage': instance.tagPage,
    };
