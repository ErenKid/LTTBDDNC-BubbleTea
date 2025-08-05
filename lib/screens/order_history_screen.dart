import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const Map<String, Color> statusColors = {
    'Đã xác nhận': Color(0xFF1976D2),
    'Vận chuyển': Color(0xFFFFA000),
    'Hoàn thành': Color(0xFF43A047),
    'Hủy': Color(0xFFD32F2F),
    'pending': Colors.grey,
  };

  String getStatusLabel(String status) {
    if (status == 'pending') return 'Đã xác nhận';
    return status;
  }
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    // Lấy user sau khi widget đã build xong để tránh lỗi context
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = context.read<MockAuthService>().currentUser;
      if (user != null) {
        final allOrders = await DatabaseService().getAllOrders();
        final userOrders = allOrders.where((o) => o.userId == user.id).toList();
        setState(() {
          _ordersFuture = Future.value(userOrders);
        });
      } else {
        setState(() {
          _ordersFuture = Future.value([]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'vi_VN');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử đơn hàng', style: TextStyle(color: AppTheme.textDark)),
        backgroundColor: AppTheme.white,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào!', style: TextStyle(fontSize: 16)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (context, i) => const SizedBox(height: 18),
            itemBuilder: (context, i) {
              final order = orders[orders.length - 1 - i];
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.receipt_long, color: AppTheme.primaryOrange, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mã đơn:', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppTheme.textDark)),
                                Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryOrange, letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: AppTheme.primaryOrange),
                                const SizedBox(width: 4),
                                Text(DateFormat('dd/MM/yyyy').format(order.createdAt),
                                  style: const TextStyle(fontSize: 13, color: AppTheme.primaryOrange, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: statusColors[order.status] ?? Colors.grey, size: 20),
                          const SizedBox(width: 6),
                          Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 14)),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (statusColors[order.status] ?? Colors.grey).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              getStatusLabel(order.status),
                              style: TextStyle(
                                color: statusColors[order.status] ?? Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: AppTheme.primaryOrange, size: 20),
                          const SizedBox(width: 4),
                          Text('${currencyFormatter.format(order.totalPrice)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryOrange)),
                          const Spacer(),
                          Icon(Icons.payment, color: AppTheme.primaryOrange, size: 18),
                          const SizedBox(width: 4),
                          Text(order.paymentMethod, style: const TextStyle(fontSize: 14, color: AppTheme.textDark, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Divider(height: 22, thickness: 1, color: Color(0xFFF2F2F2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.shopping_bag, color: AppTheme.primaryOrange, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 14)),
                                ...order.items.map((item) => Padding(
                                  padding: const EdgeInsets.only(left: 2, top: 2),
                                  child: Text('- ${item.title} x${item.quantity}', style: const TextStyle(color: AppTheme.textDark, fontSize: 14)),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(order.address, style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person, color: AppTheme.primaryOrange, size: 18),
                          const SizedBox(width: 6),
                          Text(order.name, style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 16),
                          Icon(Icons.phone, color: AppTheme.primaryOrange, size: 16),
                          const SizedBox(width: 4),
                          Text(order.phone, style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
