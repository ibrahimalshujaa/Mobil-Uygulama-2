import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'barber_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _login() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    // Validation
    if (email.isEmpty) {
      _showError('Lütfen e-posta adresinizi giriniz.');
      return;
    }
    if (!_isValidEmail(email)) {
      _showError('Geçerli bir e-posta adresi giriniz.');
      return;
    }
    if (password.isEmpty) {
      _showError('Lütfen şifrenizi giriniz.');
      return;
    }
    if (password.length < 6) {
      _showError('Şifre en az 6 karakter olmalıdır.');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final user = await authService.loginWithEmailAndPassword(email, password);
      
      if (user != null) {
        debugPrint('--- Login Success ---');
        debugPrint('UID: \${user.uid}');
        debugPrint('Email: \${user.email}');
        debugPrint('Role: \${user.role}');
        debugPrint('Firestore User Exists: true');
        
        if (mounted) {
          if (user.role == 'barber') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BarberMainScreen()));
          } else if (user.role == 'customer') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
          } else {
            _showError('Kullanıcı rolü bulunamadı.');
          }
        }
      } else {
        // If loginWithEmailAndPassword returned null, it means either auth failed or user doc doesn't exist
        debugPrint('--- Login Failed ---');
        _showError('Giriş başarısız. E-posta veya şifre hatalı.');
      }
    } catch (e) {
      debugPrint('Login exception: \$e');
      if (e.toString().contains('USER_NOT_FOUND')) {
        _showError('Kullanıcı bilgileri bulunamadı.');
      } else {
        _showError('Giriş başarısız. E-posta veya şifre hatalı.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Text('Giriş Yap', style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.textLight),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: AppColors.textLight),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Giriş Yap', style: AppTextStyles.buttonText),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text('Hesabın yok mu? Kayıt Ol', style: TextStyle(color: AppColors.primary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
