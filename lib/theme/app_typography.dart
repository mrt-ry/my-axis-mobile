import 'package:flutter/material.dart';

abstract final class AppTypography {
  AppTypography._();

  static const String _notoSansJP = 'NotoSansJP';
  static const String _zenMaruGothic = 'ZenMaruGothic';

  static const TextStyle headingLarge = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _notoSansJP,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle emotionalTitle = TextStyle(
    fontFamily: _zenMaruGothic,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle emotionalLarge = TextStyle(
    fontFamily: _zenMaruGothic,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );

  static const TextStyle emotionalMedium = TextStyle(
    fontFamily: _zenMaruGothic,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.6,
  );
}
