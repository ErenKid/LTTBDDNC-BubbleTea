import 'food_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<FoodItemModel> items;
  final int totalPrice;
  final DateTime createdAt;
  final String address;
  final String name;
  final String phone;
  final String paymentMethod;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
    required this.address,
    required this.name,
    required this.phone,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'items': items.map((e) => e.toMap()).toList(),
    'totalPrice': totalPrice,
    'createdAt': createdAt.toIso8601String(),
    'address': address,
    'name': name,
    'phone': phone,
    'paymentMethod': paymentMethod,
    'status': status,
  };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    id: map['id'],
    userId: map['userId'],
    items: (map['items'] as List).map((e) => FoodItemModel.fromMap(e)).toList(),
    totalPrice: map['totalPrice'],
    createdAt: DateTime.parse(map['createdAt']),
    address: map['address'],
    name: map['name'],
    phone: map['phone'],
    paymentMethod: map['paymentMethod'],
    status: map['status'] ?? 'pending',
  );
}
