import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = context.read<MockAuthService>().currentUser;
      if (user == null || !user.isAdmin) {
        Navigator.of(context).pushReplacementNamed('/home');
        return;
      }

      // Lấy thống kê từ database
      final categories = await DatabaseService().getAllCategories();
      final products = await DatabaseService().getAllProducts();
      final users = await DatabaseService().getAllUsers();

      // Tính toán thống kê
      final activeCategories = categories.where((c) => c.isActive).length;
      final availableProducts = products.where((p) => p.status.name == 'available').length;
      final totalValue = products.fold<int>(0, (sum, product) => sum + product.price);

      setState(() {
        _stats = {
          'totalUsers': users.length,
          'totalCategories': categories.length,
          'activeCategories': activeCategories,
          'totalProducts': products.length,
          'availableProducts': availableProducts,
          'totalValue': totalValue,
          'adminUsers': users.where((u) => u.isAdmin).length,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải thống kê: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Thống kê hệ thống',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadStatistics,
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Cards
                    const Text(
                      'Tổng quan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Tổng người dùng',
                            value: '${_stats['totalUsers'] ?? 0}',
                            icon: Icons.people,
                            color: Colors.blue,
                            subtitle: '${_stats['adminUsers'] ?? 0} admin',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Danh mục',
                            value: '${_stats['totalCategories'] ?? 0}',
                            icon: Icons.category,
                            color: Colors.green,
                            subtitle: '${_stats['activeCategories'] ?? 0} hoạt động',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Sản phẩm',
                            value: '${_stats['totalProducts'] ?? 0}',
                            icon: Icons.shopping_basket,
                            color: Colors.orange,
                            subtitle: '${_stats['availableProducts'] ?? 0} có sẵn',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Tổng giá trị',
                            value: _formatCurrency(_stats['totalValue'] ?? 0),
                            icon: Icons.monetization_on,
                            color: Colors.purple,
                            subtitle: 'VNĐ',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Detailed Statistics
                    const Text(
                      'Chi tiết thống kê',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildDetailCard(
                      title: 'Người dùng',
                      items: [
                        StatItem('Tổng số người dùng', '${_stats['totalUsers'] ?? 0}'),
                        StatItem('Admin', '${_stats['adminUsers'] ?? 0}'),
                        StatItem('Người dùng thường', '${(_stats['totalUsers'] ?? 0) - (_stats['adminUsers'] ?? 0)}'),
                      ],
                      icon: Icons.people,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    _buildDetailCard(
                      title: 'Danh mục sản phẩm',
                      items: [
                        StatItem('Tổng danh mục', '${_stats['totalCategories'] ?? 0}'),
                        StatItem('Đang hoạt động', '${_stats['activeCategories'] ?? 0}'),
                        StatItem('Ngừng hoạt động', '${(_stats['totalCategories'] ?? 0) - (_stats['activeCategories'] ?? 0)}'),
                      ],
                      icon: Icons.category,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 16),

                    _buildDetailCard(
                      title: 'Sản phẩm',
                      items: [
                        StatItem('Tổng sản phẩm', '${_stats['totalProducts'] ?? 0}'),
                        StatItem('Có sẵn', '${_stats['availableProducts'] ?? 0}'),
                        StatItem('Khác', '${(_stats['totalProducts'] ?? 0) - (_stats['availableProducts'] ?? 0)}'),
                      ],
                      icon: Icons.shopping_basket,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 32),

                    // Quick Actions
                    const Text(
                      'Hành động nhanh',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            title: 'Quản lý danh mục',
                            icon: Icons.category,
                            color: Colors.green,
                            onTap: () => Navigator.of(context).pushNamed('/category-crud'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            title: 'Quản lý sản phẩm',
                            icon: Icons.shopping_basket,
                            color: Colors.orange,
                            onTap: () => Navigator.of(context).pushNamed('/product-crud'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            title: 'Quản lý người dùng',
                            icon: Icons.people,
                            color: Colors.blue,
                            onTap: () => Navigator.of(context).pushNamed('/user-management'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            title: 'Dashboard',
                            icon: Icons.dashboard,
                            color: Colors.purple,
                            onTap: () => Navigator.of(context).pushNamed('/admin-dashboard'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'LIVE',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: color.withOpacity(0.7),
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<StatItem> items,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textLight,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class StatItem {
  final String label;
  final String value;

  StatItem(this.label, this.value);
}
