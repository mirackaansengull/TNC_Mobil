import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductRepository {
  static const String apiUrl = 'https://wantapi.com/products.php';
  static const String _assetPath = 'assets/data/products.json';

  Future<List<Product>> loadProducts() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final products = _parsePayload(decoded);
        if (products.isNotEmpty) {
          return products;
        }
      }
    } catch (_) {
      // Ağ hatasında yerel yedek veriye düşülür.
    }

    return _loadFromAsset();
  }

  List<Product> _parsePayload(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList();
      }
    }

    if (decoded is List) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Product.fromJson)
          .toList();
    }

    return [];
  }

  Future<List<Product>> _loadFromAsset() async {
    final raw = await rootBundle.loadString(_assetPath);
    return _parsePayload(json.decode(raw));
  }
}
