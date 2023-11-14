import 'dart:convert';

Stories storiesFromJson(String str) => Stories.fromJson(json.decode(str));

String storiesToJson(Stories data) => json.encode(data.toJson());

class Stories {
  bool error;
  String message;
  List<ListStory> listStory;

  Stories({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory Stories.fromJson(Map<String, dynamic> json) => Stories(
        error: json["error"],
        message: json["message"],
        listStory: List<ListStory>.from(
            json["listStory"].map((x) => ListStory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}

class Story {
  bool error;
  String message;
  ListStory story;

  Story({
    required this.error,
    required this.message,
    required this.story,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        error: json["error"],
        message: json["message"],
        story: ListStory.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}

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

  factory ListStory.fromJson(Map<String, dynamic> json) => ListStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
