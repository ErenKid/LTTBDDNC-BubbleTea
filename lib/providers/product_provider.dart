import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  // Load tất cả products từ database
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('[ProductProvider] Loading products from database...');
      final products = await DatabaseService().getAllProducts();
      print('[ProductProvider] Loaded ${products.length} products: ${products.map((p) => p.title).toList()}');
      
      _products = products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('[ProductProvider] Error loading products: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm product mới
  Future<void> addProduct(ProductModel product) async {
    try {
      await DatabaseService().addProduct(product);
      print('[ProductProvider] Added product: ${product.title}');
      
      // Thêm vào list local và notify
      _products.add(product);
      notifyListeners();
    } catch (e) {
      print('[ProductProvider] Error adding product: $e');
      rethrow;
    }
  }

  // Cập nhật product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await DatabaseService().updateProduct(product);
      print('[ProductProvider] Updated product: ${product.title}');
      
      // Tìm và cập nhật trong list local
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      print('[ProductProvider] Error updating product: $e');
      rethrow;
    }
  }

  // Xóa product
  Future<void> deleteProduct(String productId) async {
    try {
      await DatabaseService().deleteProduct(productId);
      print('[ProductProvider] Deleted product with id: $productId');
      
      // Xóa khỏi list local và notify
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      print('[ProductProvider] Error deleting product: $e');
      rethrow;
    }
  }

  // Refresh products (reload từ database)
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Lấy products theo category
  List<ProductModel> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  // Tìm kiếm products
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((p) => 
      p.title.toLowerCase().contains(lowercaseQuery) ||
      p.description.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
