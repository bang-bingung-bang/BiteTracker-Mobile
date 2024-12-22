// To parse this JSON data, do
//
//     final biteTrackerModel = biteTrackerModelFromJson(jsonString);

import 'dart:convert';

List<BiteTrackerModel> biteTrackerModelFromJson(String str) => List<BiteTrackerModel>.from(json.decode(str).map((x) => BiteTrackerModel.fromJson(x)));

String biteTrackerModelToJson(List<BiteTrackerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BiteTrackerModel {
    String model;
    String pk;
    Fields fields;

    BiteTrackerModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BiteTrackerModel.fromJson(Map<String, dynamic> json) => BiteTrackerModel(
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
    DateTime biteDate;
    String biteTime;
    String biteName;
    int biteCalories;

    Fields({
        required this.user,
        required this.biteDate,
        required this.biteTime,
        required this.biteName,
        required this.biteCalories,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        biteDate: DateTime.parse(json["bite_date"]),
        biteTime: json["bite_time"],
        biteName: json["bite_name"],
        biteCalories: json["bite_calories"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "bite_date": "${biteDate.year.toString().padLeft(4, '0')}-${biteDate.month.toString().padLeft(2, '0')}-${biteDate.day.toString().padLeft(2, '0')}",
        "bite_time": biteTime,
        "bite_name": biteName,
        "bite_calories": biteCalories,
    };
}

InfoData infoDataFromJson(String str) => InfoData.fromJson(json.decode(str));

String infoDataToJson(InfoData data) => json.encode(data.toJson());

class InfoData {
    int totalBites;
    int totalCalories;
    Meal mealCounts;
    Meal mealPercentages;

    InfoData({
        required this.totalBites,
        required this.totalCalories,
        required this.mealCounts,
        required this.mealPercentages,
    });

    factory InfoData.fromJson(Map<String, dynamic> json) => InfoData(
        totalBites: json["total_bites"],
        totalCalories: json["total_calories"],
        mealCounts: Meal.fromJson(json["meal_counts"]),
        mealPercentages: Meal.fromJson(json["meal_percentages"]),
    );

    Map<String, dynamic> toJson() => {
        "total_bites": totalBites,
        "total_calories": totalCalories,
        "meal_counts": mealCounts.toJson(),
        "meal_percentages": mealPercentages.toJson(),
    };
}

class Meal {
    int breakfast;
    int lunch;
    int dinner;
    int snack;

    Meal({
        required this.breakfast,
        required this.lunch,
        required this.dinner,
        required this.snack,
    });

    factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        breakfast: json["Breakfast"],
        lunch: json["Lunch"],
        dinner: json["Dinner"],
        snack: json["Snack"],
    );

    Map<String, dynamic> toJson() => {
        "Breakfast": breakfast,
        "Lunch": lunch,
        "Dinner": dinner,
        "Snack": snack,
    };
}

