import 'package:flutter/material.dart';

import '../models/product.dart';

class CartState extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice =>
      _items.fold(0, (sum, product) => sum + product.price);

  bool contains(Product product) =>
      _items.any((item) => item.id == product.id);

  void addProduct(Product product) {
    if (contains(product)) {
      return;
    }
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
