import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/barber_model.dart';

class BarberCard extends StatelessWidget {
  final BarberModel barber;
  final VoidCallback onTap;

  const BarberCard({super.key, required this.barber, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Icon(Icons.person, color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(barber.name, style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text(
                    barber.specialty,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 20),
                const SizedBox(width: 4),
                Text(barber.rating.toString(), style: AppTextStyles.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
