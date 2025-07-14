import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum NotificationType { share, receive, info, warning }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Đã chia sẻ thành công',
      message: 'Bạn đã chia sẻ 3 phần ăn với cộng đồng.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.share,
    ),
    NotificationItem(
      title: 'Nhận được phần ăn mới',
      message: 'Một người dùng đã gửi bạn một phần ăn.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.receive,
    ),
    NotificationItem(
      title: 'Thông báo hệ thống',
      message: 'Ứng dụng sẽ bảo trì vào 2:00 sáng mai.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.info,
    ),
  ];

  Icon _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.share:
        return const Icon(Icons.share, color: Colors.green);
      case NotificationType.receive:
        return const Icon(Icons.restaurant, color: Colors.orange);
      case NotificationType.info:
        return const Icon(Icons.info_outline, color: Colors.blue);
      case NotificationType.warning:
        return const Icon(Icons.warning, color: Colors.redAccent);
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryOrange,
        title: const Text('Thông báo', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text("Không có thông báo"))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification.title + notification.timestamp.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xóa thông báo')),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: _getIcon(notification.type),
                      title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          const SizedBox(height: 4),
                          Text(
                            _formatTimeAgo(notification.timestamp),
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
