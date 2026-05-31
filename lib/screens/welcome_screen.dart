import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Icon(Icons.style, size: 100, color: AppColors.primary),
              const SizedBox(height: 40),
              Text(
                'Berber randevunuzu kolayca oluşturun.',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Hizmet seçin, berberinizi belirleyin ve uygun saati ayırtın.',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Başla', style: AppTextStyles.buttonText),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
