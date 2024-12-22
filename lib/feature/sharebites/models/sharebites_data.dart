// To parse this JSON data, do
//
//     final shareBites = shareBitesFromJson(jsonString);

import 'dart:convert';

List<ShareBites> shareBitesFromJson(String str) => List<ShareBites>.from(json.decode(str).map((x) => ShareBites.fromJson(x)));

String shareBitesToJson(List<ShareBites> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShareBites {
    String model;
    int pk;
    Fields fields;

    ShareBites({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ShareBites.fromJson(Map<String, dynamic> json) => ShareBites(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String title;
    String content;
    String image;
    DateTime createdAt;
    String calorieContent;
    String sugarContent;
    String dietType;

    Fields({
        required this.user,
        required this.title,
        required this.content,
        required this.image,
        required this.createdAt,
        required this.calorieContent,
        required this.sugarContent,
        required this.dietType,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        calorieContent: json["calorie_content"],
        sugarContent: json["sugar_content"],
        dietType: json["diet_type"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "content": content,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "calorie_content": calorieContent,
        "sugar_content": sugarContent,
        "diet_type": dietType,
    };
}
