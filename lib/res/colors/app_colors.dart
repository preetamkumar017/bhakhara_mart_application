// lib/res/colors/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary / Accent
  static const Color primary = Color(0xFF0D47A1); // example: deep blue
  static const Color primaryVariant = Color(0xFF08306B);
  static const Color secondary = Color(0xFF00ACC1); // teal-ish

  // Backgrounds
  static const Color background = Color(0xFFF7F7FB);
  static const Color scaffoldBackground = Color(0xFFFFFFFF);

  // Surfaces & cards
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFF5F7FA);

  // Text
  static const Color textPrimary = Color(0xFF0B1B2B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders / divider
  static const Color divider = Color(0xFFE6E9EF);

  // Success / Error / Warning
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);

  // Grocery App Specific Colors
  static const Color deliveryOrange = Color(
    0xFFFF6B35,
  ); // Orange for delivery time
  static const Color promoYellow = Color(
    0xFFFFEB3B,
  ); // Yellow for promotional banner
  static const Color offerPurple = Color(
    0xFF9C27B0,
  ); // Purple for offer price button
  static const Color discountGreen = Color(
    0xFF4CAF50,
  ); // Green for discount badges

  // Dark theme equivalents (use when building ThemeData.dark())
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF0F1724);
  static const Color darkTextPrimary = Color(0xFFE6EEF6);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
