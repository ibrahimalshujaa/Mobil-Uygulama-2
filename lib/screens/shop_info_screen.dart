import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/salon_service.dart';
import '../models/service_model.dart';
import '../services/auth_service.dart';

class ShopInfoScreen extends StatelessWidget {
  const ShopInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Salon Bilgileri', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: salonService.salonSettingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final settings = snapshot.data;
          
          debugPrint('loading salon settings');
          debugPrint('salon settings exists: ${settings != null && settings.isNotEmpty}');
          debugPrint('current user role: ${authService.currentUser?.role}');

          if (settings == null || settings.isEmpty) {
            return const Center(
              child: Text(
                'Salon bilgileri henüz eklenmedi.',
                style: AppTextStyles.bodyLarge,
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.store, size: 80, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                Text(settings['salonName'] ?? 'StyleHub Barber Studio', style: AppTextStyles.heading1),
                const SizedBox(height: 16),
                Text(
                  settings['about'] ?? '',
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 32),
                const Text('İletişim & Adres', style: AppTextStyles.heading2),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, 'Adres', settings['address'] ?? 'Belirtilmedi'),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.phone, 'Telefon', settings['phone'] ?? 'Belirtilmedi'),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.access_time, 'Çalışma Saatleri', settings['workingHours'] ?? 'Belirtilmedi'),
                if (settings['instagram'] != null && settings['instagram'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.camera_alt, 'Instagram', settings['instagram']),
                ],
                if (settings['whatsapp'] != null && settings['whatsapp'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.chat, 'WhatsApp', settings['whatsapp']),
                ],
                const SizedBox(height: 32),
                const Text('Hizmetlerimiz', style: AppTextStyles.heading2),
                const SizedBox(height: 16),
                StreamBuilder<List<ServiceModel>>(
                  stream: salonService.getServices(onlyActive: true),
                  builder: (context, serviceSnapshot) {
                    if (serviceSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }
                    final services = serviceSnapshot.data ?? [];
                    if (services.isEmpty) {
                      return const Text('Henüz hizmet eklenmedi.', style: AppTextStyles.bodyLarge);
                    }
                    return Column(
                      children: services.map((s) => _buildServiceItem(s.name, '${s.duration} dk', '${s.price} ₺')).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(String name, String time, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(time, style: AppTextStyles.bodySmall),
            ],
          ),
          Text(price, style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
