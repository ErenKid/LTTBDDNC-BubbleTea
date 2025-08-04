import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
// import '../services/mock_auth_service.dart';

class OrderService {
  static Future<void> saveOrder(OrderModel order) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = order.userId;
    final key = 'orders_$userId';
    final ordersJson = prefs.getString(key);
    List list = ordersJson != null ? jsonDecode(ordersJson) : [];
    print('DEBUG: Saving order with fields:');
    print('  id: ${order.id}');
    print('  userId: ${order.userId}');
    print('  totalPrice: ${order.totalPrice}');
    print('  createdAt: ${order.createdAt}');
    print('  address: ${order.address}');
    print('  name: ${order.name}');
    print('  phone: ${order.phone}');
    print('  paymentMethod: ${order.paymentMethod}');
    print('  items:');
    for (var item in order.items) {
      print('    - id: ${item.id}, title: ${item.title}, quantity: ${item.quantity}, price: ${item.price}');
    }
    list.add(order.toMap());
    await prefs.setString(key, jsonEncode(list));
    print('DEBUG: Saved order for $userId, key=$key, total orders=${list.length}');
  }

  static Future<List<OrderModel>> getOrdersForUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'orders_$userId';
    final ordersJson = prefs.getString(key);
    print('DEBUG: ordersJson for $key = $ordersJson');
    if (ordersJson == null) return [];
    final list = jsonDecode(ordersJson) as List;
    print('DEBUG: Decoded orders list length = [32m${list.length}[0m');
    return list.map((e) => OrderModel.fromMap(e)).toList();
  }
}
