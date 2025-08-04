import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/mock_auth_service.dart';
import 'food_item_model.dart';
import 'package:flutter/material.dart';

class CartModel {
  static final ValueNotifier<List<FoodItemModel>> cartItems = ValueNotifier([]);

  // Lưu giỏ hàng theo user
  static Future<void> saveCartForCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = MockAuthService().currentUser;
    if (user == null) return;
    final key = 'cart_${user.id}';
    final cartJson = jsonEncode(cartItems.value.map((e) => e.toMap()).toList());
    await prefs.setString(key, cartJson);
  }

  // Đọc giỏ hàng theo user
  static Future<void> loadCartForCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = MockAuthService().currentUser;
    if (user == null) return;
    final key = 'cart_${user.id}';
    final cartJson = prefs.getString(key);
    if (cartJson != null) {
      final list = (jsonDecode(cartJson) as List).map((e) => FoodItemModel.fromMap(e)).toList();
      cartItems.value = List<FoodItemModel>.from(list);
    } else {
      cartItems.value = [];
    }
  }

  // Xóa giỏ hàng trên RAM (khi logout)
  static void clearCart() {
    cartItems.value = [];
  }
} 