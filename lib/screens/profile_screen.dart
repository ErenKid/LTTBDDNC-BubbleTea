import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Helper function để lấy tên cuối
  String getFirstName(String fullName) {
    final names = fullName.trim().split(' ');
    return names.isNotEmpty ? names.last : fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        final firstName = user?.name != null ? getFirstName(user!.name) : 'User';
        
        // Debug log để kiểm tra user
        print('DEBUG - Current user: ${user?.email}, isAdmin: ${user?.isAdmin}');
        
        return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header với gradient đẹp
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryOrange,
                  AppTheme.primaryOrange.withOpacity(0.8),
                ],
              ),
            ),
            padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 20, 24, 32),
            child: Row(
              children: [
                // Avatar với border đẹp
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.photoUrl != null 
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                    child: user?.photoUrl == null 
                      ? Icon(
                          Icons.person,
                          size: 36,
                          color: AppTheme.primaryOrange,
                        )
                      : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Thông tin user
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Xin chào, $firstName!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          if (user?.isAdmin == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'ADMIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user?.email ?? '[Email không xác định]',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user?.isVerified == true ? 'Đã xác thực' : 'Chưa xác thực',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu với thiết kế card đẹp
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Admin Dashboard (chỉ hiện với admin)
                  if (user?.isAdmin == true)
                    _buildMenuCard(
                      'Admin Dashboard',
                      'Quản lý hệ thống và dữ liệu',
                      Icons.admin_panel_settings,
                      AppTheme.primaryOrange,
                      () => Navigator.pushNamed(context, '/admin-dashboard'),
                    ),
                  
                  // Menu cards
                  _buildMenuCard(
                    'Thông tin cá nhân',
                    'Cài đặt và chỉnh sửa thông tin',
                    Icons.person_outline,
                    Colors.blue,
                    () {},
                  ),
                  _buildMenuCard(
                    'Lịch sử đặt hàng',
                    'Xem các đơn hàng đã đặt',
                    Icons.history,
                    Colors.green,
                    () {},
                  ),
                  _buildMenuCard(
                    'Hồ sơ kinh doanh',
                    'Chuyển sang tài khoản bán hàng',
                    Icons.business,
                    Colors.purple,
                    () {},
                  ),
                  _buildMenuCard(
                    'Thông báo',
                    'Cài đặt thông báo và cập nhật',
                    Icons.notifications,
                    Colors.orange,
                    () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  _buildMenuCard(
                    'Về ứng dụng',
                    'Thông tin phiên bản và hỗ trợ',
                    Icons.info_outline,
                    Colors.grey,
                    () {},
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout button
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade700,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                      onPressed: () async {
                        // Show confirmation dialog
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Đăng xuất'),
                            content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Đăng xuất'),
                              ),
                            ],
                          ),
                        );
                        
                        if (confirmed == true) {
                          await context.read<MockAuthService>().signOut();
                          // Chuyển về màn hình đăng nhập và xóa toàn bộ navigation stack
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/auth', 
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLight,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
