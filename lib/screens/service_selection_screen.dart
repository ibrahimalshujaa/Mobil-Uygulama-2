import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import '../services/salon_service.dart';
import '../widgets/service_card.dart';
import 'booking_screen.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hizmet Seçimi', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: salonService.getServices(onlyActive: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return const Center(child: Text('Henüz hizmet eklenmedi.', style: AppTextStyles.bodyLarge));
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ServiceCard(
                service: service,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(selectedService: service),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
