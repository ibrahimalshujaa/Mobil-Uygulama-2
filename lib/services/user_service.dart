import 'dart:async';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final _userController = StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get userStream => _userController.stream;

  Future<void> updateUserProfile(UserModel updatedUser) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Here we would normally update Firestore and Auth
    // For mock, we'll update the current user in AuthService and emit the change
    AuthService().updateCurrentUser(updatedUser);
    _userController.add(updatedUser);
  }
}

final userService = UserService();
