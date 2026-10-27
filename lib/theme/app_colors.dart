import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // ブランド
  static const Color primary = Color(0xFF4E6F96);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFF789EC8);
  static const Color primaryPressed = Color(0xFF3B5878);
  static const Color primaryTint = Color(0xFFDCE6F0);
  static const Color onPrimaryTint = Color(0xFF3B5878);
  static const Color secondary = Color(0xFFA8C7A0);
  static const Color onSecondary = Color(0xFF333B36);
  static const Color accent = Color(0xFFF5C76B);
  static const Color navSelected = Color(0xFFE6EEF6);

  // 背景・面
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF333B36);

  // 文字
  static const Color textPrimary = Color(0xFF333B36);
  static const Color textSecondary = Color(0xFF5F6B78);
  static const Color textHint = Color(0xFF8A94A0);

  // 状態
  static const Color success = Color(0xFFA8C7A0);
  static const Color info = Color(0xFF789EC8);
  static const Color warning = Color(0xFFF5C76B);
  static const Color error = Color(0xFFE57373);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color disabled = Color(0xFFCBD1D8);

  // 線
  static const Color border = Color(0xFFE3E7EC);
  static const Color shadow = Color(0x14000000);

  // カレンダー
  static const Color saturday = Color(0xFF3B6FB6);
  static const Color sunday = Color(0xFFC9403A);

  // 今日のことば
  static const Color messageBackground = Color(0xFFFBF6EC);
  static const Color messageText = Color(0xFF3D3A33);
  static const Color messageSecondary = Color(0xFF8A7A5C);
  static const Color messageRule = Color(0xFFC9B48A);
}
