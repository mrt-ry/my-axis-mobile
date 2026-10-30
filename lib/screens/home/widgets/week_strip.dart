import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/calendar_colors.dart';
import '../../../utils/date_labels.dart';
import '../../../utils/date_rules.dart';

class WeekStrip extends StatefulWidget {
  const WeekStrip({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.onSelect,
  });

  final DateTime selectedDate;
  final DateTime today;
  final ValueChanged<DateTime> onSelect;

  @override
  State<WeekStrip> createState() {
    return _WeekStripState();
  }
}

class _WeekStripState extends State<WeekStrip> {
  static const _pageDuration = Duration(milliseconds: 250);

  late final PageController _controller;
  late int _page;

  @override
  void initState() {
    super.initState();
    _page = _pageOf(widget.today);
    _controller = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeekStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSameDay(oldWidget.selectedDate, widget.selectedDate)) return;

    final target = _pageOf(widget.selectedDate);
    if (target == _page) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      // 1週以上移動する場合はUXのためアニメーションではなくジャンプする
      if ((target - _page).abs() > 1) {
        _controller.jumpToPage(target);
      } else {
        _controller.animateToPage(
          target,
          duration: _pageDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  DateTime _weekStart(int weeksAgo) {
    final base = DateRules.lastSelectableDate(widget.today);
    return DateTime(
      base.year,
      base.month,
      base.day - (base.weekday - 1) - 7 * weeksAgo,
    );
  }

  int _pageOf(DateTime date) {
    final base = DateRules.lastSelectableDate(widget.today);
    return _mondayUtc(base).difference(_mondayUtc(date)).inDays ~/ 7;
  }

  @override
  Widget build(BuildContext context) {
    final todayOnly = DateRules.dateOnly(widget.today);

    return SizedBox(
      height: 72,
      child: PageView.builder(
        reverse: true,
        controller: _controller,
        onPageChanged: (page) => setState(() {
          _page = page;
        }),
        itemBuilder: (context, page) {
          final start = _weekStart(page);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: _DayCell(
                      date: DateTime(start.year, start.month, start.day + i),
                      today: todayOnly,
                      selected: _isSameDay(
                        DateTime(start.year, start.month, start.day + i),
                        widget.selectedDate,
                      ),
                      onSelect: widget.onSelect,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.today,
    required this.selected,
    required this.onSelect,
  });

  final DateTime date;
  final DateTime today;
  final bool selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final isLocked = date.isAfter(DateRules.lastSelectableDate(today));
    final isToday = _isSameDay(date, today);

    final numberColor = selected
        ? AppColors.onPrimaryTint
        : isLocked
        ? AppColors.textHint
        : CalendarColors.forDate(date, normal: AppColors.textPrimary);

    final weekdayColor = selected
        ? AppColors.primary
        : isLocked
        ? AppColors.textHint
        : CalendarColors.forDate(date, normal: AppColors.textSecondary);

    return Semantics(
      button: !isLocked,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isLocked ? null : () => onSelect(date),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateLabels.weekday(date),
              style: AppTypography.bodySmall.copyWith(color: weekdayColor),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primaryTint : Colors.transparent,
              ),
              child: Text(
                '${date.day}',
                style: AppTypography.bodyLarge.copyWith(
                  color: numberColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isToday ? AppColors.primary : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime _mondayUtc(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day - (d.weekday - 1));
