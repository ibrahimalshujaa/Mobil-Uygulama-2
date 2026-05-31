import '../models/user_model.dart';
import 'dart:async';

class AuthService {
  static UserModel? _currentUser;
  
  // Central mock users list with passwords
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'user': UserModel(
        uid: 'user123',
        fullName: 'İbrahim',
        phone: '0555 555 5555',
        email: 'ibo@gmail.com',
        role: 'customer',
        createdAt: DateTime.now(),
      ),
      'password': '123456',
    },
    {
      'user': UserModel(
        uid: 'admin123',
        fullName: 'StyleHub Barber Studio',
        phone: '0555 555 5555',
        email: 'berber@stylehub.com',
        role: 'barber',
        createdAt: DateTime.now(),
      ),
      'password': '123456',
    },
  ];

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Stream of auth changes
  Stream<UserModel?> get authStateChanges => Stream.value(_currentUser);

  // Sign up
  Future<UserModel?> registerWithEmailAndPassword(String fullName, String phone, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    final cleanEmail = email.trim().toLowerCase();
    
    // Check if email already exists
    if (_mockUsers.any((entry) => (entry['user'] as UserModel).email == cleanEmail)) {
      return null; // Email already in use
    }
    
    final newUser = UserModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      phone: phone,
      email: cleanEmail,
      role: 'customer', // Default role for new registrations
      createdAt: DateTime.now(),
    );
    
    // Add to central mock list
    _mockUsers.add({
      'user': newUser,
      'password': password.trim(),
    });
    
    // Auto-login
    _currentUser = newUser;
    return _currentUser;
  }

  // Login
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();
    
    print('--- LOGIN DEBUG ---');
    print('Entered Email: $cleanEmail');
    print('Entered Password: $cleanPassword');
    print("Available Users: ${_mockUsers.map((e) => (e['user'] as UserModel).email).toList()}");
    
    for (var entry in _mockUsers) {
      final user = entry['user'] as UserModel;
      final storedPassword = entry['password'] as String;
      
      if (user.email == cleanEmail && storedPassword == cleanPassword) {
        print('Matched User Role: \${user.role}');
        _currentUser = user;
        return _currentUser;
      }
    }
    
    print('Login Failed: No match found');
    print('-------------------');
    return null;
  }

  // Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    // Also update in mock list
    final index = _mockUsers.indexWhere((entry) => (entry['user'] as UserModel).uid == user.uid);
    if (index != -1) {
      _mockUsers[index]['user'] = user;
    }
  }

  // Get User Data
  Future<UserModel?> getUserData() async {
    return _currentUser;
  }
}

// Add singleton pattern for easier access
final authService = AuthService();
