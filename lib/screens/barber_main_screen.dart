import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'barber_panel_screen.dart';
import 'service_management_screen.dart';
import 'profile_screen.dart';

class BarberMainScreen extends StatefulWidget {
  const BarberMainScreen({super.key});

  @override
  State<BarberMainScreen> createState() => _BarberMainScreenState();
}

class _BarberMainScreenState extends State<BarberMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BarberPanelScreen(),
    const ServiceManagementScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Panel'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Hizmetler'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
