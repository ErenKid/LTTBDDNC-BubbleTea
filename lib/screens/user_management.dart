import 'package:flutter/material.dart';

const blueTheme = Color(0xFF1E88E5);

class User {
  String username;
  String email;
  String phone;
  String password;

  User({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<User> _users = [
    User(
      username: 'admin',
      email: 'admin@example.com',
      phone: '0123456789',
      password: 'admin123',
    ),
    User(
      username: 'nhocvietnam132',
      email: 'fuoc114@gmail.com',
      phone: '0987654321',
      password: '123456',
    ),
  ];

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  void _viewOrEditUser({required User user, bool isEdit = false, int? index}) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final passwordController = TextEditingController(text: user.password);
    final confirmPasswordController = TextEditingController(text: user.password);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isEdit ? 'Chỉnh sửa người dùng' : 'Xem thông tin người dùng',
          style: TextStyle(
            color: isEdit ? Colors.amber : blueTheme,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Họ và Tên'),
                readOnly: !isEdit,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: !isEdit,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                readOnly: !isEdit,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                readOnly: !isEdit,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
                readOnly: !isEdit,
              ),
            ],
          ),
        ),
        actions: [
          if (isEdit)
            TextButton(
              onPressed: () {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu không khớp')),
                  );
                  return;
                }

                setState(() {
                  _users[index!] = User(
                    username: usernameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    password: passwordController.text,
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _addUser() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Thêm người dùng',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Họ và Tên'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mật khẩu không khớp')),
                );
                return;
              }

              setState(() {
                _users.add(User(
                  username: usernameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  password: passwordController.text,
                ));
              });

              Navigator.pop(context);
            },
            child: const Text('Thêm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color bgColor, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '👥 Quản lý tài khoản người dùng',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: blueTheme,
          ),
        ),
        iconTheme: const IconThemeData(color: blueTheme),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Thao tác',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: _users
                    .asMap()
                    .entries
                    .map(
                      (entry) => DataRow(
                        cells: [
                          DataCell(Text(entry.value.email)),
                          DataCell(Row(
                            children: [
                              _buildActionButton(
                                'Xem',
                                Colors.blue,
                                Icons.visibility,
                                () => _viewOrEditUser(user: entry.value),
                              ),
                              _buildActionButton(
                                'Sửa',
                                Colors.amber,
                                Icons.edit,
                                () => _viewOrEditUser(
                                  user: entry.value,
                                  isEdit: true,
                                  index: entry.key,
                                ),
                              ),
                              _buildActionButton(
                                'Xóa',
                                Colors.red,
                                Icons.delete,
                                () => _deleteUser(entry.key),
                              ),
                            ],
                          )),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: FloatingActionButton.extended(
              onPressed: _addUser,
              label: const Text(
                'Thêm người dùng',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              icon: const Icon(Icons.person_add, color: Colors.white),
              backgroundColor: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
