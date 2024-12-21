import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'product.dart';

class EditBitesData {
  final CookieRequest request;
  static const String baseUrl = 'http://10.0.2.2:8000';

  EditBitesData({required this.request});

  // Get products from API or local assets
  Future<List<Product>> getProducts() async {
    try {
      // Try API first
      final response = await request.get('$baseUrl/editbites/get_product_json/');
      if (response != null) {
        String jsonString = json.encode(response);
        return productFromJson(jsonString);
      }
    } catch (e) {
      print('Error fetching from API: $e');
      // If API fails, load from assets
      return getProductsFromAssets();
    }
    // If no data from API, load from assets
    return getProductsFromAssets();
  }

  // Load products from local JSON file in assets
  Future<List<Product>> getProductsFromAssets() async {
    try {
      // Read JSON file from assets
      final String response = await rootBundle.loadString('assets/data/products.json');
      print('Successfully loaded JSON file from assets');
      
      List<dynamic> jsonData = json.decode(response);
      return jsonData.map((data) => Product.fromJson(data)).toList();
      
    } catch (e) {
      print('Error loading from assets: $e');
      return [];
    }
  }

  // Get single product detail
  Future<Product> getProductDetail(int id) async {
    try {
      // Try API first
      final response = await request.get('$baseUrl/editbites/product/$id/');
      if (response != null) {
        String jsonString = json.encode(response);
        List<Product> products = productFromJson(jsonString);
        return products.first;
      }
    } catch (e) {
      print('Error fetching detail from API: $e');
      // If API fails, try local data
      final products = await getProductsFromAssets();
      final product = products.firstWhere(
        (product) => product.pk == id,
        orElse: () => throw Exception('Product not found'),
      );
      return product;
    }
    throw Exception('Failed to load product detail');
  }

  // Filter products based on criteria
  Future<List<Product>> getFilteredProducts(String filterType) async {
    try {
      List<Product> allProducts = await getProducts();
      
      switch (filterType) {
        case 'high_calories':
          return allProducts.where((p) => p.fields.calorieTag == "HIGH").toList();
        case 'low_calories':
          return allProducts.where((p) => p.fields.calorieTag == "LOW").toList();
        case 'high_sugar':
          return allProducts.where((p) => p.fields.sugarTag == "HIGH").toList();
        case 'low_sugar':
          return allProducts.where((p) => p.fields.sugarTag == "LOW").toList();
        case 'vegan':
          return allProducts.where((p) => p.fields.veganTag == "VEGAN").toList();
        case 'non_vegan':
          return allProducts.where((p) => p.fields.veganTag == "NON_VEGAN").toList();
        default:
          return allProducts;
      }
    } catch (e) {
      print('Error filtering products: $e');
      return [];
    }
  }

  // Get products by store
  Future<List<Product>> getProductsByStore(String store) async {
    try {
      List<Product> allProducts = await getProducts();
      return allProducts.where((p) => p.fields.store == store).toList();
    } catch (e) {
      print('Error getting products by store: $e');
      return [];
    }
  }

  // Get unique store list
  Future<List<String>> getStores() async {
    try {
      List<Product> products = await getProducts();
      Set<String> stores = products.map((p) => p.fields.store).toSet();
      return stores.toList()..sort();
    } catch (e) {
      print('Error getting stores list: $e');
      return [];
    }
  }

  // Create new product (admin only)
  Future<void> createProduct(Product product) async {
    try {
      final response = await request.post(
        '$baseUrl/editbites/mobile/create/',
        jsonEncode(product.toJson()),
      );
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      print('Error creating product: $e');
      throw Exception('Failed to create product: $e');
    }
  }

  // Update existing product (admin only)
  Future<void> updateProduct(int id, Product product) async {
    try {
      final response = await request.post(
        '$baseUrl/editbites/mobile/$id/edit/',
        jsonEncode(product.toJson()),
      );
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to update product');
      }
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product (admin only)
  Future<void> deleteProduct(int id) async {
    try {
      final response = await request.post(
        '$baseUrl/editbites/mobile/$id/delete/',
        {},
      );
      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      print('Error deleting product: $e');
      throw Exception('Failed to delete product: $e');
    }
  }
}