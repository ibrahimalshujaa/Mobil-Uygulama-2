import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'dart:async';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  UserModel? _currentUser;

  // Get current user
  UserModel? get currentUser => _currentUser;

  // Stream of auth changes
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        return null;
      }
      return await getUserData(firebaseUser.uid);
    });
  }

  // Sign up
  Future<UserModel?> registerWithEmailAndPassword(String fullName, String phone, String email, String password) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password.trim(),
      );
      
      User? user = result.user;
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          fullName: fullName,
          phone: phone,
          email: cleanEmail,
          role: 'customer', // Default role
          createdAt: DateTime.now(),
        );

        // Save user data in Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        _currentUser = newUser;
        return _currentUser;
      }
    } catch (e) {
      print('Register Error: \$e');
      return null;
    }
    return null;
  }

  // Login
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password.trim(),
      );
      
      User? user = result.user;
      if (user != null) {
        _currentUser = await getUserData(user.uid);
        if (_currentUser == null) {
          throw Exception('USER_NOT_FOUND');
        }
        return _currentUser;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: \${e.code}');
      throw Exception('AUTH_FAILED');
    } catch (e) {
      if (e.toString().contains('USER_NOT_FOUND')) {
        rethrow;
      }
      print('Login Error: \$e');
      throw Exception('AUTH_FAILED');
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }

  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    // Optionally update Firestore here
    _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  // Get User Data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user data: \$e');
    }
    return null;
  }

  // Get User Data (without arg)
  Future<UserModel?> getCurrentUserData() async {
    if (_auth.currentUser != null) {
      final user = await getUserData(_auth.currentUser!.uid);
      _currentUser = user;
      return user;
    }
    return _currentUser;
  }
}

// Add singleton pattern for easier access
final authService = AuthService();
