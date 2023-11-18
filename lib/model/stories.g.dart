// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
      error: json['error'] as bool,
      message: json['message'] as String,
      listStory: (json['listStory'] as List<dynamic>)
          .map((e) => ListStory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: ListStory.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };

ListStory _$ListStoryFromJson(Map<String, dynamic> json) => ListStory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ListStoryToJson(ListStory instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
