import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F0F); // Very dark gray/black background
  static const Color primary = Color(0xFFD4AF37); // Luxury Gold accent
  static const Color primaryDark = Color(0xFFAA8A29); // Darker Gold for gradients
  static const Color secondary = Color(0xFF1A1A1A); // Dark gray card background
  static const Color secondaryLight = Color(0xFF2A2A2A); // Lighter gray for highlights
  static const Color textLight = Color(0xFFFFFFFF); // White text
  static const Color textMuted = Color(0xFF9E9E9E); // Muted gray text
  static const Color error = Color(0xFFE57373); // Error red
  static const Color success = Color(0xFF81C784); // Success green
  static const Color warning = Color(0xFFFFB74D); // Warning orange
  static const Color info = Color(0xFF64B5F6); // Info blue

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF232323), Color(0xFF121212)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
