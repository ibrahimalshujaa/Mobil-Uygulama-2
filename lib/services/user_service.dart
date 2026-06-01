import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final _userController = StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get userStream => _userController.stream;

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.uid).update(updatedUser.toMap());
      // Update local state
      authService.updateCurrentUser(updatedUser);
      _userController.add(updatedUser);
    } catch (e) {
      print('Error updating user profile: \$e');
    }
  }
}

final userService = UserService();
