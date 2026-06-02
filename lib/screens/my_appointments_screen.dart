import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/appointment_model.dart';
import '../services/auth_service.dart';
import '../services/appointment_service.dart';
import '../widgets/appointment_card.dart';
import 'appointment_detail_screen.dart';

class MyAppointmentsScreen extends StatelessWidget {
  MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Randevularım', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<List<AppointmentModel>>(
                  stream: appointmentService.getUserAppointments(
                    authService.currentUser!.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Henüz randevunuz yok.',
                          style: AppTextStyles.bodyLarge,
                        ),
                      );
                    }
  
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final appointment = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentDetailScreen(appointment: appointment),
                              ),
                            );
                          },
                          child: AppointmentCard(appointment: appointment),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
