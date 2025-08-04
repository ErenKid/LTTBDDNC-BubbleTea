import 'package:flutter/material.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'id': 'DH001',
        'user': 'Nguyễn Văn A',
        'status': 'Đã xác nhận',
        'date': '2025-08-05',
        'total': 250000,
      },
      {
        'id': 'DH002',
        'user': 'Trần Thị B',
        'status': 'Vận chuyển',
        'date': '2025-08-04',
        'total': 180000,
      },
      {
        'id': 'DH003',
        'user': 'Lê Văn C',
        'status': 'Hoàn thành',
        'date': '2025-08-03',
        'total': 320000,
      },
      {
        'id': 'DH004',
        'user': 'Phạm Thị D',
        'status': 'Hủy',
        'date': '2025-08-02',
        'total': 90000,
      },
    ];
    const statusColors = {
      'Đã xác nhận': Color(0xFF42A5F5),
      'Vận chuyển': Color(0xFFFFA000),
      'Hoàn thành': Color(0xFF66BB6A),
      'Hủy': Color(0xFFD32F2F),
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, idx) {
          final order = orders[idx];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order['id'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColors[order['status'] as String],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          order['status'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Khách hàng: ${order['user']}',
                    style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ngày đặt: ${order['date']}',
                    style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xFF757575)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tổng tiền: ${order['total']} đ',
                    style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF388E3C)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline, color: Color(0xFF42A5F5)),
                        label: const Text('Chi tiết', style: TextStyle(color: Color(0xFF42A5F5), fontFamily: 'Montserrat')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
