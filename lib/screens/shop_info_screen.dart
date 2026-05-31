import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

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
      body: SingleChildScrollView(
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
            const Text('StyleHub Barber Studio', style: AppTextStyles.heading1),
            const SizedBox(height: 16),
            const Text(
              'Modern ve lüks saç kesim deneyimi için doğru yerdesiniz. Deneyimli kadromuzla, tarzınızı en iyi yansıtacak kesim ve bakım hizmetlerini sunuyoruz.',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 32),
            const Text('İletişim & Adres', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'Adres', 'Bartın Merkez, Türkiye'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.phone, 'Telefon', '+90 555 555 55 55'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.access_time, 'Çalışma Saatleri', 'Her Gün: 09:00 - 21:00'),
            const SizedBox(height: 32),
            const Text('Hizmetlerimiz', style: AppTextStyles.heading2),
            const SizedBox(height: 16),
            _buildServiceItem('Saç Kesimi', '30 dk', '250 ₺'),
            _buildServiceItem('Sakal Tıraşı', '20 dk', '150 ₺'),
            _buildServiceItem('Saç Yıkama', '15 dk', '100 ₺'),
            _buildServiceItem('Cilt Bakımı', '40 dk', '300 ₺'),
          ],
        ),
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
