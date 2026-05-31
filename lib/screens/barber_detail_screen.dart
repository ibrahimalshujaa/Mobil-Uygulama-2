import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import '../models/barber_model.dart';
import 'booking_screen.dart';

class BarberDetailScreen extends StatelessWidget {
  final ServiceModel selectedService;
  final BarberModel barber;

  const BarberDetailScreen({
    super.key,
    required this.selectedService,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Berber Detayı', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.secondary,
                      child: const Icon(Icons.person, size: 60, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(barber.name, style: AppTextStyles.heading1),
                  const SizedBox(height: 4),
                  Text(barber.specialty, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text(barber.rating.toStringAsFixed(1), style: AppTextStyles.heading3),
                      const SizedBox(width: 16),
                      const Icon(Icons.work_history, color: AppColors.primary, size: 20),
                      const SizedBox(width: 4),
                      Text('${barber.experienceYears} Yıl', style: AppTextStyles.heading3),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hakkında', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  Text(barber.description, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 24),
                  const Text('Çalışma Saatleri', style: AppTextStyles.heading2),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(barber.workingHours, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Değerlendirmeler', style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  if (barber.reviews.isEmpty)
                    const Text('Henüz değerlendirme bulunmamaktadır.', style: AppTextStyles.bodyMedium)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: barber.reviews.length,
                      itemBuilder: (context, index) {
                        final review = barber.reviews[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.secondaryLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(review.userName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: AppColors.primary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(review.rating.toStringAsFixed(1), style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(review.comment, style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.background,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    selectedService: selectedService,
                    selectedBarber: barber,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Bu Berberi Seç', style: AppTextStyles.buttonText),
          ),
        ),
      ),
    );
  }
}
