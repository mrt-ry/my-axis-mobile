import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4E6F96);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFF789EC8);
  static const Color secondary = Color(0xFFA8C7A0);
  static const Color onSecondary = Color(0xFF333B36);
  static const Color accent = Color(0xFFF5C76B);
  static const Color background = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF333B36);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF333B36);

  // 状態色
  static const Color success = Color(0xFFA8C7A0);
  static const Color info = Color(0xFF789EC8);
  static const Color warning = Color(0xFFF5C76B);
  static const Color error = Color(0xFFE57373);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color disabled = Color(0xFFCBD1D8);

  // 部品
  static const Color border = Color(0xFFE3E7EC);
}
