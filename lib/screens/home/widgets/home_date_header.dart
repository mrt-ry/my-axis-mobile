import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/date_labels.dart';
import '../../../utils/holiday_calendar.dart';
import '../../../theme/calendar_colors.dart';

class HomeDateHeader extends StatelessWidget {
  const HomeDateHeader({
    super.key,
    required this.date,
    required this.onCalendarTap,
  });

  final DateTime date;
  final VoidCallback onCalendarTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final holidayName = HolidayCalendar.nameOf(date);
    final weekdayColor = CalendarColors.forDate(
      date,
      normal: AppColors.textSecondary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text.rich(
                  TextSpan(
                    text: DateLabels.monthDay(date),
                    style: text.headlineSmall,
                    children: [
                      TextSpan(
                        text: ' ${DateLabels.weekdayParen(date)}',
                        style: text.bodyMedium?.copyWith(color: weekdayColor),
                      ),
                      if (holidayName != null)
                        TextSpan(
                          text: ' $holidayName',
                          style: text.bodyMedium?.copyWith(color: weekdayColor),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onCalendarTap,
            tooltip: 'カレンダー',
            color: AppColors.textSecondary,
            icon: const Icon(Symbols.calendar_month_rounded),
          ),
        ],
      ),
    );
  }
}
