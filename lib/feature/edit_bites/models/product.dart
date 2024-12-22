//lib\feature\edit_bites\models\product.dart

import 'dart:convert';

List<Product> productFromJson(String str) => 
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String model;
  int pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };

  @override
  String toString() {
    return 'Product(pk: $pk, name: ${fields.name}, store: ${fields.store}, price: ${fields.price})';
  }
}

class Fields {
  String store;
  String name;
  int price;
  String description;
  int calories;
  String calorieTag;
  String veganTag;
  String sugarTag;
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
    store: json["store"],
    name: json["name"],
    price: json["price"],
    description: json["description"],
    calories: json["calories"],
    calorieTag: json["calorie_tag"],
    veganTag: json["vegan_tag"],
    sugarTag: json["sugar_tag"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "store": store,
    "name": name,
    "price": price,
    "description": description,
    "calories": calories,
    "calorie_tag": calorieTag,
    "vegan_tag": veganTag,
    "sugar_tag": sugarTag,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  static Map<String, String> getStoreChoices() {
    return {
      'QITA_MART': 'QITA MART, Jl. K.H.M. Usman No.38, Kukusan, Kecamatan Beji, Kota Depok, Jawa Barat 16425',
      'TUTUL_V_MARKET': 'Tutul V Market, Jl. Margonda No.358, Kemiri Muka, Kecamatan Beji, Kota Depok, Jawa Barat 16423',
      'AL_HIKAM_MART': 'Al Hikam Mart, Jl. H. Amat No.21, Kukusan, Kecamatan Beji, Kota Depok, Jawa Barat 16425',
      'SNACK_JAYA_MARKET': 'Snack Jaya Market, Jl. Cagar Alam Sel. No.60, RT.01/RW.02, Pancoran MAS, Kec. Pancoran Mas, Kota Depok, Jawa Barat 16436',
      'BELANDA_MART': 'Belanda Mart, Jl. Tole Iskandar No.3, Mekar Jaya, Kec. Sukmajaya, Kota Depok, Jawa Barat 16411',
    };
  }

  String getStoreDisplay() {
    return getStoreChoices()[store] ?? store;
  }

  @override
  String toString() {
    return 'Fields(name: $name, price: $price, description: $description)';
  }
}