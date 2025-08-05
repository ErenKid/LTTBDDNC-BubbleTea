import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import 'database_service.dart';

class OrderService {
  static Future<void> saveOrder(OrderModel order) async {
    // Lưu đơn hàng vào database SQLite
    print('DEBUG: Saving order to SQLite database...');
    await DatabaseService().addOrder(order);
    print('DEBUG: Saved order to database for userId=${order.userId}');
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
