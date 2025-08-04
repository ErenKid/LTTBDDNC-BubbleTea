import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<MockAuthService>().currentUser;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    // Nếu có ảnh đại diện local thì load
    // (Có thể mở rộng lưu path ảnh vào user.photoUrl nếu cần)
  }
  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _avatarFile = File(picked.path);
      });
      // TODO: Lưu path ảnh vào user.photoUrl nếu muốn lưu vĩnh viễn
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final authService = context.read<MockAuthService>();
    final currentUser = authService.currentUser;
    if (currentUser == null) return;
    // Tạo user mới với thông tin đã chỉnh sửa
    final updatedUser = currentUser.copyWith(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );
    // Debug: log thông tin user
    print('Update user: id=${updatedUser.id}, email=${updatedUser.email}, password=${updatedUser.password}');
    // Cập nhật vào database
    final updateResult = await DatabaseService().updateUser(updatedUser);
    print('Update result: $updateResult');
    if (updateResult == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể cập nhật thông tin!')),
      );
      return;
    }
    // Lấy lại user mới nhất từ database và cập nhật vào MockAuthService
    final refreshedUser = await DatabaseService().loginUser(updatedUser.email, updatedUser.password);
    print('Refreshed user: ${refreshedUser?.toMap()}');
    if (refreshedUser != null) {
      authService.currentUser = refreshedUser; // Dùng setter công khai
      // Không gọi notifyListeners ở đây vì sẽ lỗi
    }
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật thông tin thành công!')),
    );
  }

  void _changePassword() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đổi mật khẩu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPassController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu cũ',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu mới',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authService = context.read<MockAuthService>();
                final user = authService.currentUser;
                if (user == null) return;
                if (oldPassController.text != user.password) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu cũ không đúng!')),
                  );
                  return;
                }
                if (newPassController.text != confirmPassController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu mới không khớp!')),
                  );
                  return;
                }
                if (newPassController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu mới phải từ 6 ký tự!')),
                  );
                  return;
                }
                // Cập nhật mật khẩu
                final updatedUser = user.copyWith(password: newPassController.text);
                await DatabaseService().updateUser(updatedUser);
                authService.currentUser = updatedUser;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đổi mật khẩu thành công!')),
                );
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<MockAuthService>().currentUser;
    print('DEBUG PROFILE USER: $user');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    backgroundImage: _avatarFile != null
                        ? FileImage(_avatarFile!)
                        : (user?.photoUrl != null && (user?.photoUrl?.isNotEmpty ?? false))
                            ? NetworkImage(user!.photoUrl!) as ImageProvider
                            : null,
                    child: (_avatarFile == null && (user?.photoUrl == null || (user?.photoUrl?.isEmpty ?? true)))
                        ? Icon(Icons.person, size: 56, color: AppTheme.primaryOrange)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: isEditing ? _pickAvatar : null,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      enabled: isEditing,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(Icons.person, color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: emailController,
                      enabled: false,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(Icons.email, color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: phoneController,
                      enabled: isEditing,
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                        hintStyle: const TextStyle(color: Colors.black54),
                        prefixIcon: const Icon(Icons.phone, color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isEditing ? _saveProfile : () => setState(() => isEditing = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            child: Text(isEditing ? 'Lưu' : 'Chỉnh sửa'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _changePassword,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryOrange,
                              side: const BorderSide(color: AppTheme.primaryOrange),
                              textStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Đổi mật khẩu'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
