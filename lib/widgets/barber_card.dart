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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.secondaryLight, width: 1),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.secondaryLight,
                child: Icon(Icons.person, color: AppColors.primary, size: 36),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(barber.name, style: AppTextStyles.heading3),
                  const SizedBox(height: 6),
                  Text(barber.specialty, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(barber.rating.toString(), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
