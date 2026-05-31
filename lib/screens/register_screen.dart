import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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

  void _register() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    // Validation
    if (name.isEmpty) {
      _showError('Lütfen ad ve soyadınızı giriniz.');
      return;
    }
    if (phone.isEmpty) {
      _showError('Lütfen telefon numaranızı giriniz.');
      return;
    }
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
    
    final user = await authService.registerWithEmailAndPassword(
      name,
      phone,
      email,
      password,
    );
    
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } else {
      _showError('Kayıt başarısız. Lütfen tekrar deneyin.');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Kayıt Ol', style: AppTextStyles.heading1, textAlign: TextAlign.center),
              const SizedBox(height: 40),
              _buildTextField(_nameController, 'Ad Soyad', TextInputType.name),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, 'Telefon Numarası', TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'E-posta', TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, 'Şifre', TextInputType.text, obscureText: true),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Kayıt Ol', style: AppTextStyles.buttonText),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType keyboardType, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textLight),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.secondary)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
      ),
    );
  }
}
