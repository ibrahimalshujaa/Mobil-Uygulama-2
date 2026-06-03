import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import '../models/appointment_model.dart';
import '../services/auth_service.dart';
import '../services/appointment_service.dart';
import 'main_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final ServiceModel selectedService;
  final DateTime selectedDate;
  final String selectedTime;

  const ConfirmationScreen({
    super.key,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isLoading = false;

  void _confirmBooking() async {
    setState(() => _isLoading = true);
    
    try {
      final user = await authService.getCurrentUserData();
      final dateStr = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      if (user == null) {
        debugPrint('--- Booking Error: User is null ---');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Oturum bulunamadı. Lütfen tekrar giriş yapın.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      debugPrint('--- Confirming Booking ---');
      debugPrint('UID: \${user.uid}');
      debugPrint('Service: \${widget.selectedService.name}');
      debugPrint('Date: \$dateStr');
      debugPrint('Time: \${widget.selectedTime}');

      AppointmentModel newAppointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        userName: user.fullName,
        serviceId: widget.selectedService.id,
        serviceName: widget.selectedService.name,
        barberId: 'stylehub',
        barberName: 'StyleHub Barber Studio',
        date: dateStr,
        time: widget.selectedTime,
        price: widget.selectedService.price,
        status: 'Bekliyor',
        createdAt: DateTime.now(),
      );

      String result = await appointmentService.createAppointment(newAppointment);

      if (result == 'success') {
        
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Randevunuz başarıyla oluşturuldu.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text('Randevunuz Başarıyla Oluşturuldu!', style: AppTextStyles.heading2, textAlign: TextAlign.center),
            content: const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Randevularım', style: TextStyle(color: AppColors.background)),
                ),
              ),
            ],
          ),
        );
      } else if (result == 'conflict') {
        debugPrint('Firestore save error: Conflict found');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bu tarih ve saat için zaten bir randevu var. Lütfen farklı bir saat seçin.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        debugPrint('Firestore save error: Failed to save appointment');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Randevu oluşturulamadı. Lütfen tekrar deneyin.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Firestore save error: \$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Randevu oluşturulamadı. Lütfen tekrar deneyin.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd.MM.yyyy').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Randevu Onayı', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary),
              ),
              child: Column(
                children: [
                  const Icon(Icons.store, color: AppColors.primary, size: 60),
                  const SizedBox(height: 16),
                  const Text('StyleHub Barber Studio', style: AppTextStyles.heading2),
                  const SizedBox(height: 32),
                  _buildSummaryRow('Hizmet', widget.selectedService.name),
                  const Divider(color: AppColors.secondaryLight, height: 32),
                  _buildSummaryRow('Tarih', dateStr),
                  const Divider(color: AppColors.secondaryLight, height: 32),
                  _buildSummaryRow('Saat', widget.selectedTime),
                  const Divider(color: AppColors.secondaryLight, height: 32),
                  _buildSummaryRow('Ücret', '${widget.selectedService.price} ₺'),
                  const Divider(color: AppColors.secondaryLight, height: 32),
                  _buildSummaryRow('Durum', 'Bekliyor', valueColor: const Color.fromARGB(255, 171, 139, 34)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.background)
                    : const Text(
                        'Randevuyu Onayla',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.background),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color valueColor = AppColors.textLight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(color: valueColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
