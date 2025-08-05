import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  static const Map<String, Color> statusColors = {
    'Đã xác nhận': Color(0xFF1976D2),
    'Vận chuyển': Color(0xFFFFA000),
    'Hoàn thành': Color(0xFF43A047),
    'Hủy': Color(0xFFD32F2F),
    'pending': Colors.grey,
  };
  void showOrderDetailDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: Color(0xFF1976D2), size: 26),
            SizedBox(width: 10),
            Text('Chi tiết đơn hàng', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.qr_code, color: Color(0xFF1976D2), size: 20),
                  SizedBox(width: 6),
                  Text('Mã đơn:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Expanded(child: Text(order.id, style: TextStyle(color: Colors.black87))),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.person, color: Color(0xFF388E3C), size: 20),
                  SizedBox(width: 6),
                  Text('Khách:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Expanded(child: Text(order.name, style: TextStyle(color: Colors.black87))),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFF1976D2), size: 18),
                  SizedBox(width: 6),
                  Text('SĐT:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Expanded(child: Text(order.phone, style: TextStyle(color: Colors.black87))),
                ],
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Color(0xFF1976D2), size: 18),
                  SizedBox(width: 6),
                  Text('Địa chỉ:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Expanded(child: Text(order.address, style: TextStyle(color: Colors.black87))),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Color(0xFF757575), size: 18),
                  SizedBox(width: 6),
                  Text('Ngày đặt:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Text(order.createdAt.toString().substring(0, 16), style: TextStyle(color: Colors.black87)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.payment, color: Color(0xFF1976D2), size: 18),
                  SizedBox(width: 6),
                  Text('Phương thức:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Text(order.paymentMethod, style: TextStyle(color: Colors.black87)),
                ],
              ),
              SizedBox(height: 12),
              Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 4, top: 2),
                child: Text('- ${item.title} x${item.quantity}', style: TextStyle(color: Colors.black87)),
              )),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.attach_money, color: Color(0xFF388E3C), size: 20),
                  SizedBox(width: 6),
                  Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Text('${order.totalPrice} đ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF388E3C))),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.info, color: Color(0xFF1976D2), size: 18),
                  SizedBox(width: 6),
                  Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 4),
                  Text(getStatusLabel(order.status), style: TextStyle(fontWeight: FontWeight.bold, color: statusColors[order.status] ?? Colors.black)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Đóng', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
  final List<String> statusOptions = [
    'pending', // cho đơn hàng cũ
    'Đã xác nhận',
    'Vận chuyển',
    'Hoàn thành',
    'Hủy',
  ];

  String getStatusLabel(String status) {
    if (status == 'pending') return 'Đã xác nhận';
    return status;
  }

  Future<void> updateOrderStatus(OrderModel order, String newStatus) async {
    final updatedOrder = OrderModel(
      id: order.id,
      userId: order.userId,
      items: order.items,
      totalPrice: order.totalPrice,
      createdAt: order.createdAt,
      address: order.address,
      name: order.name,
      phone: order.phone,
      paymentMethod: order.paymentMethod,
      status: newStatus,
    );
    await DatabaseService().updateOrder(updatedOrder);
    setState(() {});
  }

  Future<void> deleteOrderAndRefresh(String orderId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFD32F2F), size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Xác nhận xóa đơn hàng',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              'Bạn có chắc chắn muốn xóa đơn hàng này không?',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Thao tác này không thể hoàn tác!',
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xFFD32F2F), fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFFD32F2F),
              backgroundColor: Color(0xFFFFEBEE),
              textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseService().deleteOrder(orderId);
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 0.5),
        ),
        backgroundColor: Color(0xFFAED581), // xanh lá nhạt
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: FutureBuilder<List<OrderModel>>(
        future: DatabaseService().getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}', style: TextStyle(fontFamily: 'Montserrat')));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Không có đơn hàng nào.', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemCount: orders.length,
            itemBuilder: (context, idx) {
              final order = orders[idx];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: Color(0xFF1976D2), size: 22),
                          const SizedBox(width: 8),
                          Text('Mã đơn: ', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(order.id, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black87)),
                          const Spacer(),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: order.status,
                              dropdownColor: Colors.white,
                              style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black),
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1976D2)),
                              items: statusOptions.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColors[status] ?? Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      getStatusLabel(status),
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null && newStatus != order.status) {
                                  updateOrderStatus(order, newStatus);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.person, color: Color(0xFF388E3C), size: 18),
                          const SizedBox(width: 6),
                          Text('Khách: ', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(order.name, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500, color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF757575), size: 16),
                          const SizedBox(width: 6),
                          Text('Ngày đặt: ', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),
                          Text(order.createdAt.toString().substring(0, 10), style: TextStyle(fontFamily: 'Montserrat', color: Colors.black87)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Color(0xFF388E3C), size: 18),
                          const SizedBox(width: 6),
                          Text('Tổng: ', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Colors.black)),
                          Text('${order.totalPrice} đ', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: Color(0xFF388E3C))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => showOrderDetailDialog(context, order),
                            icon: Icon(Icons.info_outline, color: Color(0xFF1976D2)),
                            label: Text('Chi tiết', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFF1976D2), fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE3F2FD),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () => deleteOrderAndRefresh(order.id),
                            icon: Icon(Icons.delete_outline, color: Color(0xFFD32F2F)),
                            label: Text('Xóa', style: TextStyle(fontFamily: 'Montserrat', color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFEBEE),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            ),
                          ),
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