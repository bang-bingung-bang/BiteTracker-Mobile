// lib/models/product.dart

enum CalorieTag {
  HIGH('HIGH', 'Tinggi'),
  LOW('LOW', 'Rendah');

  final String value;
  final String label;
  const CalorieTag(this.value, this.label);

  static CalorieTag fromString(String value) {
    return CalorieTag.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CalorieTag.LOW,
    );
  }
}

enum VeganTag {
  VEGAN('VEGAN', 'Vegan'),
  NON_VEGAN('NON_VEGAN', 'Non-vegan');

  final String value;
  final String label;
  const VeganTag(this.value, this.label);

  static VeganTag fromString(String value) {
    return VeganTag.values.firstWhere(
      (e) => e.value == value,
      orElse: () => VeganTag.NON_VEGAN,
    );
  }
}

enum SugarTag {
  HIGH('HIGH', 'Tinggi'),
  LOW('LOW', 'Rendah');

  final String value;
  final String label;
  const SugarTag(this.value, this.label);

  static SugarTag fromString(String value) {
    return SugarTag.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SugarTag.LOW,
    );
  }
}

enum Store {
  QITA_MART(
    'QITA_MART',
    'QITA MART, Jl. K.H.M. Usman No.38, Kukusan, Kecamatan Beji, Kota Depok, Jawa Barat 16425',
  ),
  TUTUL_V_MARKET(
    'TUTUL_V_MARKET',
    'Tutul V Market, Jl. Margonda No.358, Kemiri Muka, Kecamatan Beji, Kota Depok, Jawa Barat 16423',
  ),
  AL_HIKAM_MART(
    'AL_HIKAM_MART',
    'Al Hikam Mart, Jl. H. Amat No.21, Kukusan, Kecamatan Beji, Kota Depok, Jawa Barat 16425',
  ),
  SNACK_JAYA_MARKET(
    'SNACK_JAYA_MARKET',
    'Snack Jaya Market, Jl. Cagar Alam Sel. No.60, RT.01/RW.02, Pancoran MAS, Kec. Pancoran Mas, Kota Depok, Jawa Barat 16436',
  ),
  BELANDA_MART(
    'BELANDA_MART',
    'Belanda Mart, Jl. Tole Iskandar No.3, Mekar Jaya, Kec. Sukmajaya, Kota Depok, Jawa Barat 16411',
  );

  final String value;
  final String address;
  const Store(this.value, this.address);

  static Store fromString(String value) {
    return Store.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Store.QITA_MART,
    );
  }
}

class Product {
  final int? id;
  final Store store;
  final String name;
  final int price;
  final String description;
  final int calories;
  final CalorieTag calorieTag;
  final VeganTag veganTag;
  final SugarTag sugarTag;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    this.id,
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['pk'],
      store: Store.fromString(json['fields']['store']),
      name: json['fields']['name'],
      price: json['fields']['price'],
      description: json['fields']['description'],
      calories: json['fields']['calories'],
      calorieTag: CalorieTag.fromString(json['fields']['calorie_tag']),
      veganTag: VeganTag.fromString(json['fields']['vegan_tag']),
      sugarTag: SugarTag.fromString(json['fields']['sugar_tag']),
      image: json['fields']['image'],
      createdAt: DateTime.parse(json['fields']['created_at']),
      updatedAt: DateTime.parse(json['fields']['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': 'editbites.product',
      if (id != null) 'pk': id,
      'fields': {
        'store': store.value,
        'name': name,
        'price': price,
        'description': description,
        'calories': calories,
        'calorie_tag': calorieTag.value,
        'vegan_tag': veganTag.value,
        'sugar_tag': sugarTag.value,
        'image': image,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      },
    };
  }

  String getStoreDisplay() {
    return store.address;
  }

  String getImageUrl() {
    if (image.isNotEmpty) {
      return image;
    }
    return 'https://placehold.co/400x300?text=${name.replaceAll(' ', '+')}';
  }

  @override
  String toString() {
    return '$name - ${getStoreDisplay()}';
  }

  Product copyWith({
    int? id,
    Store? store,
    String? name,
    int? price,
    String? description,
    int? calories,
    CalorieTag? calorieTag,
    VeganTag? veganTag,
    SugarTag? sugarTag,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      store: store ?? this.store,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      calorieTag: calorieTag ?? this.calorieTag,
      veganTag: veganTag ?? this.veganTag,
      sugarTag: sugarTag ?? this.sugarTag,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}