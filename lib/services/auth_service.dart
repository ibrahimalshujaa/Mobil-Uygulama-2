import '../models/user_model.dart';
import 'dart:async';

class AuthService {
  static UserModel? _currentUser = UserModel(
    uid: 'user123',
    fullName: 'İbrahim',
    phone: '0555 555 5555',
    email: 'ibo@gmail.com',
    role: 'user',
    createdAt: DateTime.now(),
  );

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Stream of auth changes
  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);

  // Sign up
  Future<UserModel?> registerWithEmailAndPassword(String fullName, String phone, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    _currentUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      phone: phone,
      email: email,
      role: 'user', // Default role
      createdAt: DateTime.now(),
    );
    return _currentUser;
  }

  // Login
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    // Admin login shortcut
    if (email == 'admin@admin.com') {
      _currentUser = UserModel(
        uid: 'admin123',
        fullName: 'Admin User',
        phone: '1234567890',
        email: 'admin@admin.com',
        role: 'admin',
        createdAt: DateTime.now(),
      );
    } else {
      _currentUser = UserModel(
        uid: 'user123',
        fullName: 'İbrahim',
        phone: '0555 555 5555',
        email: 'ibo@gmail.com', // Always mock to ibo@gmail.com
        role: 'user',
        createdAt: DateTime.now(),
      );
    }
    return _currentUser;
  }

  // Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
  }

  // Get User Data
  Future<UserModel?> getUserData() async {
    return _currentUser;
  }
}

// Add singleton pattern for easier access
final authService = AuthService();
