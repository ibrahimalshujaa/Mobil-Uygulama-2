import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class BarberPanelScreen extends StatelessWidget {
  BarberPanelScreen({super.key});

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final appointments = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('İstatistikler', style: AppTextStyles.heading2),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Toplam Müşteri', '125', Icons.people, color: AppColors.primary)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStatCard('Toplam Gelir', '18.500 ₺', Icons.account_balance_wallet, color: AppColors.success)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildStatCard('Bugünkü Randevular', '12', Icons.calendar_today, color: AppColors.warning)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStatCard('Bu Ayki Randevular', '85', Icons.date_range, color: AppColors.info)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildStatCard('En Popüler Hizmet', 'Saç Kesimi', Icons.star, color: AppColors.primary),
                      const SizedBox(height: 32),
                      const Text('Randevu İstatistikleri', style: AppTextStyles.heading2),
                      const SizedBox(height: 16),
                      Container(
                        height: 250,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.secondaryLight),
                        ),
                        child: _buildBarChart(),
                      ),
                      const SizedBox(height: 32),
                      const Text('Tüm Randevular', style: AppTextStyles.heading2),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (appointments.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Henüz randevunuz bulunmamaktadır.', style: AppTextStyles.bodyLarge),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final appointment = appointments[index];
                      return _buildPanelAppointmentCard(appointment, context);
                    },
                    childCount: appointments.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold, fontSize: 10);
                Widget text;
                switch (value.toInt()) {
                  case 0: text = const Text('Pzt', style: style); break;
                  case 1: text = const Text('Sal', style: style); break;
                  case 2: text = const Text('Çar', style: style); break;
                  case 3: text = const Text('Per', style: style); break;
                  case 4: text = const Text('Cum', style: style); break;
                  case 5: text = const Text('Cmt', style: style); break;
                  case 6: text = const Text('Paz', style: style); break;
                  default: text = const Text('', style: style); break;
                }
                return SideTitleWidget(meta: meta, space: 4.0, child: text);
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeGroupData(0, 5),
          _makeGroupData(1, 8),
          _makeGroupData(2, 6),
          _makeGroupData(3, 10),
          _makeGroupData(4, 12),
          _makeGroupData(5, 15),
          _makeGroupData(6, 7),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.primary,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color color = AppColors.textLight}) {
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

  Widget _buildPanelAppointmentCard(AppointmentModel appointment, BuildContext context) {
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
              Text('${appointment.userName} - ${appointment.date} ${appointment.time}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              Text(appointment.status, style: TextStyle(color: appointment.status == 'İptal Edildi' ? AppColors.error : AppColors.primary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(appointment.serviceName, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 16),
          if (appointment.status == 'Bekliyor' || appointment.status == 'Onaylandı') ...[
            Row(
              children: [
                if (appointment.status == 'Bekliyor') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => appointmentService.updateAppointmentStatus(appointment.id, 'Onaylandı'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                      child: const Text('Onayla', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => appointmentService.updateAppointmentStatus(appointment.id, 'Tamamlandı'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
                    child: const Text('Tamamlandı', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => appointmentService.updateAppointmentStatus(appointment.id, 'İptal Edildi'),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                    child: const Text('İptal Et', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
