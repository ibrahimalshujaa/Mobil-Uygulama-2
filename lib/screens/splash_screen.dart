import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'welcome_screen.dart';
import 'main_screen.dart';
import 'barber_main_screen.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a small delay for the splash screen to be visible
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final user = await authService.getCurrentUserData();
      
      if (!mounted) return;

      if (user != null) {
        debugPrint('--- Auto Login Success ---');
        debugPrint('current user uid: ${user.uid}');
        debugPrint('current user email: ${user.email}');
        debugPrint('current user role: ${user.role}');

        if (user.role == 'barber' || user.role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BarberMainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        debugPrint('--- Auto Login Failed ---');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.content_cut, size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            Text('StyleHub', style: AppTextStyles.heading1.copyWith(fontSize: 40)),
            const SizedBox(height: 10),
            Text('Premium Barber Shop', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
