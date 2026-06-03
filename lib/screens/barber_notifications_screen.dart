import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class BarberNotificationsScreen extends StatefulWidget {
  const BarberNotificationsScreen({super.key});

  @override
  State<BarberNotificationsScreen> createState() => _BarberNotificationsScreenState();
}

class _BarberNotificationsScreenState extends State<BarberNotificationsScreen> {
  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} gün önce';
    if (diff.inHours > 0) return '${diff.inHours} saat önce';
    if (diff.inMinutes > 0) return '${diff.inMinutes} dk önce';
    return 'Az önce';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bildirimler', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.error),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.secondary,
                  title: const Text('Tümünü Temizle', style: AppTextStyles.heading2),
                  content: const Text('Tüm bildirimleri silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sil', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await notificationService.deleteAllBarberNotifications();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getUserNotifications('barber', 'barber'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(child: Text('Yeni bildiriminiz yok.', style: AppTextStyles.bodyLarge));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif.title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(notif.message, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(_formatTimeAgo(notif.createdAt), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontSize: 10)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.secondary,
                            title: const Text('Bildirimi Sil', style: AppTextStyles.heading2),
                            content: const Text('Bu bildirimi silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sil', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await notificationService.deleteNotification(notif.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
