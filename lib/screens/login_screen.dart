import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final user = await _authService.loginWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (user != null) {
      if (user.role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız. Bilgilerinizi kontrol edin.')),
      );
    }
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
              Text('Giriş Yap', style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: TextStyle(color: AppColors.textLight),
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: AppColors.textLight),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(color: AppColors.textMuted),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Giriş Yap', style: AppTextStyles.buttonText),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
                child: Text('Hesabın yok mu? Kayıt Ol', style: TextStyle(color: AppColors.primary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
