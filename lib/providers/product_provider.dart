import 'package:flutter/material.dart';
import 'package:route_task/models/product_model.dart';
import 'package:route_task/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  bool _isSearching = false;

  List<Product> get products => _filteredProducts.isNotEmpty ? _filteredProducts : _products;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  final ProductService _productService = ProductService();

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.fetchProducts();
      _filteredProducts = [];
    } catch (e) {
      print(e);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
      _isSearching = false;
    } else {
      _filteredProducts = _products
          .where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = true;
    }
    notifyListeners();
  }
}
