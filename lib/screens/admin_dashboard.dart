import '../services/database_service.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedTab = 0;

  final List<Widget> _tabs = [
    _DashboardHome(),
    _OrderManagementTab(),
  ];

  @override
  Widget build(BuildContext context) {
    const greenTheme = Color(0xFFAED581);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: greenTheme,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
        ],
      ),
      body: _tabs[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: greenTheme,
        unselectedItemColor: Colors.grey[500],
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
        ],
      ),
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    const greenTheme = Color(0xFFAED581);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: greenTheme,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng Admin! 👋',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quản lý hệ thống một cách dễ dàng và hiệu quả',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Thêm các widget thống kê, shortcut ở đây nếu muốn
          ],
        ),
      ),
    );
  }
}

class _OrderManagementTab extends StatefulWidget {
  const _OrderManagementTab();

  @override
  State<_OrderManagementTab> createState() => _OrderManagementTabState();
}

class _OrderManagementTabState extends State<_OrderManagementTab> {
  List orders = [];
  bool _loading = true;

  static const statusColors = {
    'Đã xác nhận': Color(0xFF42A5F5),
    'Vận chuyển': Color(0xFFFFA000),
    'Hoàn thành': Color(0xFF66BB6A),
    'Hủy': Color(0xFFD32F2F),
  };

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _loading = true);
    final db = await (await importDatabaseService());
    final fetched = await db.getAllOrders();
    setState(() {
      orders = fetched;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders.isEmpty) {
      return const Center(child: Text('Chưa có đơn hàng nào.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, idx) {
        final order = orders[idx];
        final id = order.id;
        final status = order.status ?? 'Đã xác nhận';
        final name = order.name;
        final date = order.createdAt;
        final total = order.totalPrice;
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
                      id,
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
                        color: statusColors[status] ?? Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
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
                  'Khách hàng: $name',
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ngày đặt: ${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: Color(0xFF757575)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng tiền: $total đ',
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
    );
  }
}

// Helper để import DatabaseService mà không lỗi circular import
Future<dynamic> importDatabaseService() async {
  // ignore: import_of_legacy_library_into_null_safe
  return await Future.value(DatabaseService());
}
