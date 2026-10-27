import 'package:flutter/material.dart';
import 'package:my_axis_mobile/screens/home/widgets/daily_message_section.dart';

import 'widgets/home_date_header.dart';
import 'widgets/week_strip.dart';
import '../../theme/app_spacing.dart';
import '../../utils/date_rules.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _today = DateTime.now();
  late DateTime _selectedDate = _today;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(_selectedDate),
      firstDate: DateRules.firstSelectableDate,
      lastDate: DateRules.lastSelectableDate(_today),
    );

    // カレンダー選択のキャンセル、カレンダーがない場合は中止
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.md),
            HomeDateHeader(date: _selectedDate, onCalendarTap: _pickDate),
            WeekStrip(
              selectedDate: _selectedDate,
              today: _today,
              onSelect: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: AppSpacing.lg),
            const DailyMessageSection(
              message: '急がなくていい。\n今日の自分に、正直でいられたら。',
              author: '作者名',
            ),
          ],
        ),
      ),
    );
  }
}
