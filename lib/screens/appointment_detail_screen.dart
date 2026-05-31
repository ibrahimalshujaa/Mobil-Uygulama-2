import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const AppointmentDetailScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late AppointmentModel _appointment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Future<void> _cancelAppointment() async {
    setState(() => _isLoading = true);
    await appointmentService.updateAppointmentStatus(_appointment.id, 'İptal Edildi');
    setState(() {
      _appointment = _appointment.copyWith(status: 'İptal Edildi');
      _isLoading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Randevu iptal edildi.')),
      );
    }
  }

  void _giveReview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: const Text('Değerlendirme Yap', style: AppTextStyles.heading2),
        content: const Text('Bu özellik çok yakında eklenecektir.', style: AppTextStyles.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text('Randevu Detayı', style: AppTextStyles.heading2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Column(
        children: [
          _buildDetailRow('Hizmet', _appointment.serviceName),
          const Divider(color: AppColors.secondaryLight, height: 32),
          _buildDetailRow('Tarih', _appointment.date),
          const Divider(color: AppColors.secondaryLight, height: 32),
          _buildDetailRow('Saat', _appointment.time),
          const Divider(color: AppColors.secondaryLight, height: 32),
          _buildDetailRow('Ücret', '${_appointment.price} ₺'),
          const Divider(color: AppColors.secondaryLight, height: 32),
          _buildStatusRow('Durum', _appointment.status),
          const Divider(color: AppColors.secondaryLight, height: 32),
          _buildDetailRow(
            'Oluşturulma', 
            DateFormat('dd.MM.yyyy HH:mm').format(_appointment.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 16)),
        Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildStatusRow(String label, String status) {
    Color statusColor;
    if (status == 'Bekliyor') statusColor = Colors.orange;
    else if (status == 'Onaylandı') statusColor = Colors.blue;
    else if (status == 'Tamamlandı') statusColor = Colors.green;
    else statusColor = Colors.red; // İptal Edildi

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 16)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_appointment.status == 'Bekliyor' || _appointment.status == 'Onaylandı') {
      return SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _cancelAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading 
              ? const CircularProgressIndicator(color: Colors.red)
              : const Text('Randevuyu İptal Et', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    } else if (_appointment.status == 'Tamamlandı') {
      return SizedBox(
        height: 55,
        child: ElevatedButton(
          onPressed: _giveReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Değerlendirme Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
