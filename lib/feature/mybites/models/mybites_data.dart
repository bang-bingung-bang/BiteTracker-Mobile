// To parse this JSON data, do
//
//     final myBitesData = myBitesDataFromJson(jsonString);

import 'dart:convert';

List<MyBitesData> myBitesDataFromJson(String str) => List<MyBitesData>.from(json.decode(str).map((x) => MyBitesData.fromJson(x)));

String myBitesDataToJson(List<MyBitesData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBitesData {
  Model model;
  int pk;
  Fields fields;

  MyBitesData({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory MyBitesData.fromJson(Map<String, dynamic> json) => MyBitesData(
    model: modelValues.map[json["model"]]!,
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": modelValues.reverse[model],
    "pk": pk,
    "fields": fields.toJson(),
  };

  @override
  String toString() {
    return 'MyBitesData(pk: $pk, name: ${fields.name}, store: ${fields.store}, price: ${fields.price})';
  }
}

class Fields {
  Store store;
  String name;
  int price;
  String description;
  int calories;
  Tag calorieTag;
  VeganTag veganTag;
  Tag sugarTag;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  Fields({
    required this.store,
    required this.name,
    required this.price,
    required this.description,
    required this.calories,
    required this.calorieTag,
    required this.veganTag,
    required this.sugarTag,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    store: storeValues.map[json["store"]]!,
    name: json["name"],
    price: json["price"],
    description: json["description"],
    calories: json["calories"],
    calorieTag: tagValues.map[json["calorie_tag"]]!,
    veganTag: veganTagValues.map[json["vegan_tag"]]!,
    sugarTag: tagValues.map[json["sugar_tag"]]!,
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "store": storeValues.reverse[store],
    "name": name,
    "price": price,
    "description": description,
    "calories": calories,
    "calorie_tag": tagValues.reverse[calorieTag],
    "vegan_tag": veganTagValues.reverse[veganTag],
    "sugar_tag": tagValues.reverse[sugarTag],
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  @override
  String toString() {
    return 'Fields(name: $name, price: $price, description: $description)';
  }
}

enum Tag {
    HIGH,
    LOW
}

final tagValues = EnumValues({
    "HIGH": Tag.HIGH,
    "LOW": Tag.LOW
});

enum Store {
    AL_HIKAM_MART,
    BELANDA_MART,
    QITA_MART,
    SNACK_JAYA_MARKET,
    TUTUL_V_MARKET
}

final storeValues = EnumValues({
    "AL_HIKAM_MART": Store.AL_HIKAM_MART,
    "BELANDA_MART": Store.BELANDA_MART,
    "QITA_MART": Store.QITA_MART,
    "SNACK_JAYA_MARKET": Store.SNACK_JAYA_MARKET,
    "TUTUL_V_MARKET": Store.TUTUL_V_MARKET
});

enum VeganTag {
    NON_VEGAN,
    VEGAN
}

final veganTagValues = EnumValues({
    "NON_VEGAN": VeganTag.NON_VEGAN,
    "VEGAN": VeganTag.VEGAN
});

enum Model {
    EDITBITES_PRODUCT
}

final modelValues = EnumValues({
    "editbites.product": Model.EDITBITES_PRODUCT
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
