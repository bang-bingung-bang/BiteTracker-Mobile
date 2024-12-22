// lib/feature/edit_bites/models/editbites_data.dart

import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bite_tracker_mobile/feature/authentication/models/user_models.dart';
import 'package:bite_tracker_mobile/feature/edit_bites/models/product.dart';

class EditBitesData {
  final CookieRequest request;
  static const String baseUrl = 'https://faiz-akram-bitetracker.pbp.cs.ui.ac.id/productbites';

  EditBitesData({required this.request});

  Future<List<Product>> getProducts() async {
    try {
      final response = await request.get('$baseUrl/get_product_json/');
      
      if (response != null) {
        List<dynamic> jsonList = response;
        List<Product> products = [];
        
        for (var item in jsonList) {
          try {
            products.add(Product(
              model: item['model'] ?? 'editbites.product',
              pk: item['pk'] ?? 0,
              fields: Fields(
                store: item['fields']['store'] ?? '',
                name: item['fields']['name'] ?? '',
                price: item['fields']['price'] ?? 0,
                description: item['fields']['description'] ?? '',
                calories: item['fields']['calories'] ?? 0,
                calorieTag: item['fields']['calorie_tag'] ?? '',
                veganTag: item['fields']['vegan_tag'] ?? '',
                sugarTag: item['fields']['sugar_tag'] ?? '',
                image: item['fields']['image'] ?? '',
                createdAt: DateTime.parse(item['fields']['created_at'] ?? DateTime.now().toIso8601String()),
                updatedAt: DateTime.parse(item['fields']['updated_at'] ?? DateTime.now().toIso8601String()),
              ),
            ));
          } catch (e) {
          }
        }
        return products;
      } else {
        throw Exception('Failed to load products from API.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductDetail(int id) async {
    try {
      final response = await request.get('$baseUrl/get_product_json/');

      if (response != null && response is List && response.isNotEmpty) {
        var productItem = response.firstWhere((item) => item['pk'] == id, orElse: () => null);
        
        if (productItem != null) {
          return Product(
            model: productItem['model'] ?? 'editbites.product',
            pk: productItem['pk'] ?? 0,
            fields: Fields(
              store: productItem['fields']['store'] ?? '',
              name: productItem['fields']['name'] ?? '',
              price: productItem['fields']['price'] ?? 0,
              description: productItem['fields']['description'] ?? '',
              calories: productItem['fields']['calories'] ?? 0,
              calorieTag: productItem['fields']['calorie_tag'] ?? '',
              veganTag: productItem['fields']['vegan_tag'] ?? '',
              sugarTag: productItem['fields']['sugar_tag'] ?? '',
              image: productItem['fields']['image'] ?? '',
              createdAt: DateTime.parse(productItem['fields']['created_at'] ?? DateTime.now().toIso8601String()),
              updatedAt: DateTime.parse(productItem['fields']['updated_at'] ?? DateTime.now().toIso8601String()),
            ),
          );
        }
      }
      throw Exception('Product not found');
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createProduct(Product product) async {
    if (logInUser?.role != true) {
      throw Exception('Unauthorized: Admin access required');
    }

    try {
      final response = await request.post(
        '$baseUrl/mobile/create/',
        jsonEncode({
          'fields': {
            'store': product.fields.store,
            'name': product.fields.name,
            'price': product.fields.price,
            'description': product.fields.description,
            'calories': product.fields.calories,
            'calorie_tag': product.fields.calorieTag,
            'vegan_tag': product.fields.veganTag,
            'sugar_tag': product.fields.sugarTag,
            'image': product.fields.image,
          }
        }),
      );

      if (response['status'] == 'success') {
        return response['message'];
      } else {
        throw Exception(response['message'] ?? 'Failed to create product.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateProduct(int id, Product product) async {
    if (logInUser?.role != true) {
      throw Exception('Unauthorized: Admin access required');
    }

    try {
      final response = await request.post(
        '$baseUrl/mobile/$id/edit/',
        jsonEncode({
          'fields': {
            'store': product.fields.store,
            'name': product.fields.name,
            'price': product.fields.price,
            'description': product.fields.description,
            'calories': product.fields.calories,
            'calorie_tag': product.fields.calorieTag,
            'vegan_tag': product.fields.veganTag,
            'sugar_tag': product.fields.sugarTag,
            'image': product.fields.image,
          }
        }),
      );

      if (response['status'] == 'success') {
        return response['message'];
      } else {
        throw Exception(response['message'] ?? 'Failed to update product.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteProduct(int id) async {
    if (logInUser?.role != true) {
      throw Exception('Unauthorized: Admin access required');
    }

    try {
      final response = await request.post(
        '$baseUrl/mobile/$id/delete/',
        {},
      );

      if (response['status'] == 'success') {
        return response['message'];
      } else {
        throw Exception(response['message'] ?? 'Failed to delete product.');
      }
    } catch (e) {
      rethrow;
    }
  }
}