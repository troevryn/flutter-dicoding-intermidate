import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stories.g.dart';
@JsonSerializable()
class Stories {
  bool error;
  String message;
  List<ListStory> listStory;

  Stories({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory Stories.fromJson(Map<String, dynamic> json) => _$StoriesFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesToJson(this);
}
@JsonSerializable()
class Story {
  bool error;
  String message;
  ListStory story;

  Story({
    required this.error,
    required this.message,
    required this.story,
  });

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
@JsonSerializable()
class ListStory {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory ListStory.fromJson(Map<String, dynamic> json) => _$ListStoryFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryToJson(this);
}
Stories storiesFromJson(String str) => Stories.fromJson(json.decode(str));

String storiesToJson(Stories data) => json.encode(data.toJson());
