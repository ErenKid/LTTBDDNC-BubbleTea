import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  // Load tất cả categories từ database
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('[CategoryProvider] Loading categories from database...');
      final categories = await DatabaseService().getAllCategories();
      print('[CategoryProvider] Loaded ${categories.length} categories: ${categories.map((c) => c.name).toList()}');
      
      _categories = categories;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('[CategoryProvider] Error loading categories: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm category mới
  Future<void> addCategory(CategoryModel category) async {
    try {
      await DatabaseService().addCategory(category);
      print('[CategoryProvider] Added category: ${category.name}');
      
      // Thêm vào list local và notify
      _categories.add(category);
      notifyListeners();
    } catch (e) {
      print('[CategoryProvider] Error adding category: $e');
      rethrow;
    }
  }

  // Cập nhật category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await DatabaseService().updateCategory(category);
      print('[CategoryProvider] Updated category: ${category.name}');
      
      // Tìm và cập nhật trong list local
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      print('[CategoryProvider] Error updating category: $e');
      rethrow;
    }
  }

  // Xóa category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await DatabaseService().deleteCategory(categoryId);
      print('[CategoryProvider] Deleted category: $categoryId');
      
      // Xóa khỏi list local và notify
      _categories.removeWhere((c) => c.id == categoryId);
      notifyListeners();
    } catch (e) {
      print('[CategoryProvider] Error deleting category: $e');
      rethrow;
    }
  }

  // Refresh categories (pull-to-refresh)
  Future<void> refreshCategories() async {
    await loadCategories();
  }
}
