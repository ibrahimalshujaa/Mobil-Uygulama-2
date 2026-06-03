import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/appointment_model.dart';
import '../models/notification_model.dart';
import '../services/appointment_service.dart';
import '../services/review_service.dart';
import '../services/notification_service.dart';
import 'reviews_screen.dart';
import 'barber_notifications_screen.dart';

class BarberPanelScreen extends StatefulWidget {
  const BarberPanelScreen({super.key});

  @override
  State<BarberPanelScreen> createState() => _BarberPanelScreenState();
}

class _BarberPanelScreenState extends State<BarberPanelScreen> {
  String _selectedFilter = 'Tümü';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Berber Paneli', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: StreamBuilder<List<AppointmentModel>>(
        stream: appointmentService.getAllAppointments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Bir hata oluştu: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final appointments = snapshot.data ?? [];
          final allAppointments = appointments;
          final activeAppointments = appointments
              .where((a) => !a.isArchived)
              .toList();

          final today = DateTime.now();

          final pendingAppointments = activeAppointments
              .where((a) => a.status == 'Bekliyor')
              .length;
          final uniqueCustomers = allAppointments
              .map((a) => a.userId)
              .toSet()
              .length;

          final completedAppts = allAppointments
              .where((a) => a.status == 'Tamamlandı')
              .toList();
          final totalRevenue = completedAppts.fold(
            0.0,
            (sum, a) => sum + a.price,
          );

          debugPrint('--- TODAY REVENUE CALCULATION ---');
          debugPrint('today date: $today');
          
          double todayRevenue = 0.0;
          for (var a in allAppointments) {
            bool included = false;
            
            if (a.status == 'Tamamlandı') {
              try {
                DateTime? apptDate;
                final dateStr = a.date;
                if (dateStr.contains('.')) {
                  final parts = dateStr.split('.');
                  if (parts.length == 3) {
                     apptDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                  }
                } else if (dateStr.contains('/')) {
                  final parts = dateStr.split('/');
                  if (parts.length == 3) {
                     apptDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                  }
                } else if (dateStr.contains('-')) {
                  final parts = dateStr.split('-');
                  if (parts.length == 3) {
                    if (parts[0].length == 4) {
                       apptDate = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
                    } else {
                       apptDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                    }
                  }
                }
                
                if (apptDate != null && 
                    apptDate.year == today.year && 
                    apptDate.month == today.month && 
                    apptDate.day == today.day) {
                  included = true;
                  todayRevenue += a.price;
                }
              } catch (e) {
                debugPrint('Error parsing date: ${a.date} - $e');
              }
            }

            debugPrint('appointment date: ${a.date}');
            debugPrint('appointment status: ${a.status}');
            debugPrint('appointment price: ${a.price}');
            debugPrint('included in today revenue: $included');
          }
          debugPrint('final today revenue: $todayRevenue');
          debugPrint('---------------------------------');

          List<AppointmentModel> filteredAppointments = activeAppointments;
          if (_selectedFilter != 'Tümü') {
            filteredAppointments = activeAppointments
                .where((a) => a.status == _selectedFilter)
                .toList();
          }

          debugPrint('stats appointments count: ${allAppointments.length}');
          debugPrint('stats completed count: ${completedAppts.length}');
          debugPrint('today revenue: $todayRevenue');
          debugPrint('total revenue: $totalRevenue');

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationsSection(),
                      const SizedBox(height: 32),
                      const Text(
                        'İstatistikler',
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Toplam Müşteri',
                              '$uniqueCustomers',
                              Icons.people,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Bekleyen Randevu',
                              '$pendingAppointments',
                              Icons.hourglass_empty,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Bugünkü Gelir',
                              '${todayRevenue.toStringAsFixed(0)} ₺',
                              Icons.account_balance_wallet,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard(
                              'Toplam Gelir',
                              '${totalRevenue.toStringAsFixed(0)} ₺',
                              Icons.savings,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text('Randevular', style: AppTextStyles.heading2),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              [
                                    'Tümü',
                                    'Bekliyor',
                                    'Onaylandı',
                                    'Tamamlandı',
                                    'İptal Edildi',
                                  ]
                                  .map(
                                    (filter) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: ChoiceChip(
                                        label: Text(filter),
                                        selected: _selectedFilter == filter,
                                        selectedColor: const Color.fromARGB(
                                          255,
                                          171,
                                          139,
                                          34,
                                        ),
                                        backgroundColor: AppColors.secondary,
                                        labelStyle: TextStyle(
                                          color: _selectedFilter == filter
                                              ? AppColors.background
                                              : AppColors.textLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(
                                              () => _selectedFilter = filter,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (filteredAppointments.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Bu filtreye uygun randevu yok',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final appointment = filteredAppointments[index];
                    return _buildPanelAppointmentCard(appointment, context);
                  }, childCount: filteredAppointments.length),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Müşteri Değerlendirmeleri',
                        style: AppTextStyles.heading2,
                      ),
                      const SizedBox(height: 16),
                      _buildReviewsSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return StreamBuilder<List<NotificationModel>>(
      stream: notificationService.getUserNotifications('barber', 'barber'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final notifications = snapshot.data ?? [];
        final unreadCount = notifications.where((n) => !n.isRead).length;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Yeni Bildirimler', style: AppTextStyles.heading2),
                  if (unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount Yeni',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (notifications.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.notifications,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notifications.first.title,
                        style: AppTextStyles.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarberNotificationsScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Bildirimleri Gör'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsSection() {
    return StreamBuilder<List<dynamic>>(
      stream: reviewService.getReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final reviews = snapshot.data ?? [];

        double avgRating = 0.0;
        if (reviews.isNotEmpty) {
          double total = 0.0;
          for (var review in reviews) {
            final data = review.data() as Map<String, dynamic>;
            total += (data['rating'] ?? 5.0).toDouble();
          }
          avgRating = total / reviews.length;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.secondaryLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toplam Değerlendirme',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reviews.length}',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Ortalama Puan',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            avgRating.toStringAsFixed(1),
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReviewsScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tüm Değerlendirmeleri Gör'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon, {
    Color color = AppColors.textLight,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildPanelAppointmentCard(
    AppointmentModel appointment,
    BuildContext context,
  ) {
    Color statusColor;
    switch (appointment.status) {
      case 'Bekliyor':
        statusColor = const Color.fromARGB(255, 171, 139, 34);
        break;
      case 'Onaylandı':
        statusColor = Colors.blue;
        break;
      case 'Tamamlandı':
        statusColor = Colors.green;
        break;
      case 'İptal Edildi':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppColors.textMuted;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.userName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.cut, color: AppColors.textMuted, size: 16),
              const SizedBox(width: 8),
              Text(appointment.serviceName, style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${appointment.date}  ${appointment.time}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              Text(
                '${appointment.price} ₺',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.textMuted,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Talep Zamanı: ${appointment.createdAt.day.toString().padLeft(2, '0')}.${appointment.createdAt.month.toString().padLeft(2, '0')}.${appointment.createdAt.year} ${appointment.createdAt.hour.toString().padLeft(2, '0')}:${appointment.createdAt.minute.toString().padLeft(2, '0')}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (appointment.status == 'Bekliyor') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => appointmentService.updateAppointmentStatus(
                      appointment.id,
                      'Onaylandı',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Onayla',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => appointmentService.updateAppointmentStatus(
                      appointment.id,
                      'İptal Edildi',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text(
                      'İptal Et',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (appointment.status == 'Onaylandı') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => appointmentService.updateAppointmentStatus(
                  appointment.id,
                  'Tamamlandı',
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Tamamlandı',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ] else if (appointment.status == 'Tamamlandı' ||
              appointment.status == 'İptal Edildi') ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.secondary,
                      title: const Text('Sil', style: AppTextStyles.heading2),
                      content: const Text(
                        'Bu randevuyu silmek istediğinize emin misiniz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Sil',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await appointmentService.deleteAppointment(appointment.id);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: 20,
                ),
                label: const Text(
                  'Sil',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
