import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/notification_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
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
          StreamBuilder<List<NotificationModel>>(
            stream: notificationService.getUserNotifications(
              authService.currentUser!.uid,
              authService.currentUser!.role,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return IconButton(
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
                      await notificationService.deleteAllUserNotifications(authService.currentUser!.uid);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getUserNotifications(
          authService.currentUser!.uid,
          authService.currentUser!.role,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final notifications = snapshot.data ?? [];
          
          debugPrint('--- Notifications Screen ---');
          debugPrint('Current notification screen user uid: ${authService.currentUser!.uid}');
          debugPrint('Current notification screen user role: ${authService.currentUser!.role}');
          debugPrint('Notifications loaded count: ${notifications.length}');

          if (notifications.isEmpty) {
            return const Center(
              child: Text('Henüz bildiriminiz yok.', style: AppTextStyles.bodyLarge),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
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
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif.title, style: AppTextStyles.bodyLarge),
                          if (notif.message.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(notif.message, style: AppTextStyles.bodyMedium),
                          ],
                          const SizedBox(height: 8),
                          Text(_formatTimeAgo(notif.createdAt), style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.secondary,
                            title: const Text('Bildirimi Sil', style: AppTextStyles.heading2),
                            content: const Text('Bu bildirimi silmek istiyor musunuz?'),
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
                          debugPrint('customer notification deleted id: ${notif.id}');
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
