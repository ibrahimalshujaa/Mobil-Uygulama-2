import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
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
