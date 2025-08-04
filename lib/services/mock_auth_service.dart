import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class MockAuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  set currentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  MockAuthService() {
    _init();
  }

  void _init() {
    // Simulate loading
    _isLoading = true;
    notifyListeners();
    
    // Simulate checking for existing user
    Future.delayed(const Duration(seconds: 1), () {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
        password: password,
        photoUrl: null,
        phoneNumber: null,
        address: null,
        latitude: null,
        longitude: null,
        rating: 0,
        totalShares: 0,
        totalReceives: 0,
        isVerified: false,
      );

      _currentUser = user;
      return user;
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Lấy user từ database để có đủ thông tin
      final user = await DatabaseService().loginUser(email, password);
      if (user != null) {
        _currentUser = user;
        print('DEBUG - User set: ${user.email}, isAdmin: ${user.isAdmin}');
        return user;
      } else {
        print('DEBUG - Login failed: user not found');
        return null;
      }
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        latitude: latitude,
        longitude: longitude,
        password: _currentUser!.password,
      );

      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    if (_currentUser == null) return;

    try {
      final updatedUser = _currentUser!.copyWith(photoUrl: photoUrl, password: _currentUser!.password);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating profile photo: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      print('Password reset email sent to: $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      rethrow;
    }
  }
} 