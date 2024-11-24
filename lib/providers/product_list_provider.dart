// lib/providers/product_list_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<String> _productSuggestions = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<String> get productSuggestions => _productSuggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductListProvider() {
    fetchProductSuggestions();
  }

  Future<void> fetchProductSuggestions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _productSuggestions = await _apiService.fetchProducts();
    } catch (e) {
      _error = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  List<String> getSuggestions(String query) {
    return _productSuggestions
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
