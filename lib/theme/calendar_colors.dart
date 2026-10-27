import 'package:flutter/material.dart';

import '../utils/holiday_calendar.dart';
import 'app_colors.dart';

abstract final class CalendarColors {
  CalendarColors._();

  // 休日（祝日・日曜）・土曜・平日のいずれかの色を返す
  // 平日の場合はnormalを返す
  static Color forDate(DateTime date, {required Color normal}) {
    if (HolidayCalendar.nameOf(date) != null) return AppColors.sunday;
    if (date.weekday == DateTime.sunday) return AppColors.sunday;
    if (date.weekday == DateTime.saturday) return AppColors.saturday;
    return normal;
  }
}
