import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockNotifications = [
      {'title': 'Randevunuz yarın saat 14:00\'te.', 'time': '10 Dk Önce', 'icon': Icons.calendar_today, 'color': AppColors.primary},
      {'title': 'StyleHub Barber Studio randevunuzu onayladı.', 'time': '1 Saat Önce', 'icon': Icons.check_circle, 'color': AppColors.success},
      {'title': 'Yeni saç modelleri eklendi.', 'time': 'Dün', 'icon': Icons.face, 'color': AppColors.info},
      {'title': 'Randevunuz başarıyla oluşturuldu.', 'time': '2 Gün Önce', 'icon': Icons.done_all, 'color': AppColors.primary},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bildirimler', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: mockNotifications.isEmpty
          ? const Center(
              child: Text('Bildiriminiz bulunmamaktadır.', style: AppTextStyles.bodyLarge),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: mockNotifications.length,
              itemBuilder: (context, index) {
                final notif = mockNotifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondaryLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: notif['color'].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(notif['icon'], color: notif['color']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notif['title'], style: AppTextStyles.bodyLarge),
                            const SizedBox(height: 4),
                            Text(notif['time'], style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
