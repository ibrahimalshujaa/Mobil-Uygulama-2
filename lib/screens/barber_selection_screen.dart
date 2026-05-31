import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import '../models/barber_model.dart';
import '../services/mock_data_service.dart';
import '../widgets/barber_card.dart';
import 'booking_screen.dart';
import 'barber_detail_screen.dart';

class BarberSelectionScreen extends StatelessWidget {
  final ServiceModel selectedService;

  BarberSelectionScreen({super.key, required this.selectedService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Berber Seçimi', style: AppTextStyles.heading3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hizmet: ${selectedService.name}',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  final barbers = MockDataService.barbers;

                  if (barbers.isEmpty) {
                    return Center(
                      child: Text(
                        'Berber bulunamadı.',
                        style: AppTextStyles.bodyLarge,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: barbers.length,
                    itemBuilder: (context, index) {
                      final barber = barbers[index];
                      return BarberCard(
                        barber: barber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarberDetailScreen(
                                selectedService: selectedService,
                                barber: barber,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
