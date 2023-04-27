// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_string.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteString _$FavoriteStringFromJson(Map<String, dynamic> json) =>
    FavoriteString()
      ..id = json['_id'] as String?
      ..title = json['title'] as String?
      ..favorited = json['favorited'] as bool? ?? false;

Map<String, dynamic> _$FavoriteStringToJson(FavoriteString instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'favorited': instance.favorited,
    };
