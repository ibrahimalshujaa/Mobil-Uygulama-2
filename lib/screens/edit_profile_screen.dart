
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final newPhone = _phoneController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != newEmail) {
        debugPrint('Old auth email: ${user.email}');
        debugPrint('New email: $newEmail');
        
        try {
          await user.verifyBeforeUpdateEmail(newEmail);
          await user.reload(); // Reload user model immediately
          debugPrint('Firebase Auth verifyBeforeUpdateEmail called successfully');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'requires-recent-login') {
            debugPrint('Requires recent login: true');
            final password = await _promptForPassword();
            if (password == null || password.isEmpty) {
              setState(() => _isLoading = false);
              return;
            }
            
            final cred = EmailAuthProvider.credential(
              email: user.email!, 
              password: password
            );
            await user.reauthenticateWithCredential(cred);
            
            await user.verifyBeforeUpdateEmail(newEmail);
            await user.reload(); // Reload user model immediately
            debugPrint('Firebase Auth verifyBeforeUpdateEmail called successfully after reauth');
          } else {
            rethrow;
          }
        }
      }

      final authUid = user?.uid ?? '';
      final widgetUid = widget.user.uid;
      final actualUid = widgetUid.isNotEmpty ? widgetUid : authUid;

      debugPrint('--- KAYDET PRESSED ---');
      debugPrint('FirebaseAuth UID: $authUid');
      debugPrint('widget.user.uid: $widgetUid');
      debugPrint('actualUid being used: $actualUid');
      debugPrint('Document path being used: users/$actualUid');

      if (actualUid.isEmpty) {
        throw Exception('UID is empty');
      }

      final updatedUser = widget.user.copyWith(
        uid: actualUid,
        fullName: newName,
        email: newEmail, // Force Firestore to update email immediately
        phone: newPhone,
      );

      try {
        await userService.updateUserProfile(updatedUser);
        debugPrint('Firestore update success for path: users/$actualUid');
      } catch (e) {
        debugPrint('Firestore update failure for path: users/$actualUid, error: $e');
        rethrow;
      }

      authService.updateCurrentUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil başarıyla güncellendi.'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, updatedUser);
      }
    } catch (e, stackTrace) {
      debugPrint('================ UPDATE EMAIL ERROR ================');
      debugPrint('Update profile error: $e');
      if (e is FirebaseAuthException) {
        debugPrint('Code: ${e.code}');
        debugPrint('Message: ${e.message}');
      }
      debugPrint('StackTrace: $stackTrace');
      debugPrint('====================================================');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _promptForPassword() async {
    if (!mounted) return null;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Güvenlik nedeniyle e-posta değiştirmek için tekrar giriş yapmanız gerekiyor.'),
        backgroundColor: AppColors.warning,
      ),
    );

    String? password;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String input = '';
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: const Text('Şifrenizi Girin', style: AppTextStyles.heading3),
          content: TextField(
            obscureText: true,
            style: const TextStyle(color: AppColors.textLight),
            onChanged: (val) => input = val,
            decoration: const InputDecoration(
              hintText: 'Mevcut Şifreniz',
              hintStyle: TextStyle(color: AppColors.textMuted),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                password = input;
                Navigator.pop(context);
              },
              child: const Text('Onayla', style: TextStyle(color: AppColors.background)),
            ),
          ],
        );
      }
    );
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text('Profili Düzenle', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              label: 'Ad Soyad',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'E-posta',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              label: 'Telefon Numarası',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: AppColors.background)
                    : const Text(
                        'Kaydet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.secondary,
      ),
    );
  }
}


