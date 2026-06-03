import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

import 'login_screen.dart';

import 'gallery_screen.dart';
import 'edit_profile_screen.dart';
import 'my_appointments_screen.dart';
import 'salon_settings_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout(BuildContext context) async {
    await authService.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: userService.userStream,
      initialData: authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final user = snapshot.data;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                decoration: const BoxDecoration(
                  gradient: AppColors.darkGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.secondary,
                        child: Icon(Icons.person, size: 50, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(user?.fullName ?? 'Kullanıcı', style: AppTextStyles.heading2),
                    const SizedBox(height: 4),
                    Text(user?.role == 'barber' ? 'Aktif Berber' : 'Aktif Müşteri', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [

                    _buildProfileItem(Icons.email, 'E-posta', (user?.email != null && user!.email.isNotEmpty) ? user.email : 'Belirtilmemiş'),
                    const SizedBox(height: 16),
                    _buildProfileItem(Icons.phone, 'Telefon Numarası', (user?.phone != null && user!.phone.isNotEmpty) ? user.phone : 'Belirtilmemiş'),
                    const SizedBox(height: 24),
                    if (user?.role == 'barber') ...[
                      _buildProfileButton(
                        context,
                        icon: Icons.store,
                        label: 'Salon Ayarları',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SalonSettingsScreen()));
                        },
                      ),

                      const SizedBox(height: 12),
                      _buildProfileButton(
                        context,
                        icon: Icons.face,
                        label: 'Saç Modelleri',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const GalleryScreen()));
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (user?.role == 'customer') ...[
                      _buildProfileButton(
                        context,
                        icon: Icons.calendar_today,
                        label: 'Randevularım',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppointmentsScreen()));
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    _buildProfileButton(
                      context,
                      icon: Icons.edit,
                      label: 'Profili Düzenle',
                      onPressed: () {
                        if (user != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)));
                        }
                      },
                    ),


                    const SizedBox(height: 12),
                    _buildProfileButton(
                      context,
                      icon: Icons.logout,
                      label: 'Çıkış Yap',
                      isDestructive: true,
                      onPressed: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed, bool isDestructive = false}) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    final bgColor = isDestructive ? AppColors.error.withValues(alpha: 0.1) : AppColors.secondary;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        label: Text(label, style: AppTextStyles.buttonText.copyWith(color: isDestructive ? color : AppColors.textLight)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDestructive ? AppColors.error.withValues(alpha: 0.5) : AppColors.primary),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
