import 'food_item_model.dart';
import 'package:flutter/material.dart';

class CartModel {
  static final ValueNotifier<List<FoodItemModel>> cartItems = ValueNotifier([]);
} 