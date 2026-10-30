import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/action_providers.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../utils/date_rules.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_button.dart';
import '../../widgets/section_title.dart';
import '../next_step/next_step_screen.dart';
import '../reflection/reflection_screen.dart';
import 'widgets/daily_message_section.dart';
import 'widgets/home_date_header.dart';
import 'widgets/next_step_summary.dart';
import 'widgets/step_item.dart';
import 'widgets/week_strip.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.onOpenAxis});

  final VoidCallback onOpenAxis;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final DateTime _today = DateRules.today();
  late DateTime _selectedDate = _today;

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(_selectedDate),
      firstDate: DateRules.firstSelectableDate,
      lastDate: DateRules.lastSelectableDate(_today),
    );

    // カレンダー選択のキャンセル、画面がすでに閉じられている場合は中止
    if (picked == null || !mounted) return;
    _selectDate(picked);
  }

  void _openNextStep() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            NextStepScreen(date: _selectedDate, onOpenAxis: widget.onOpenAxis),
      ),
    );
  }

  void _openReflection() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReflectionScreen(date: _selectedDate),
      ),
    );
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
              onSelect: _selectDate,
            ),
            const SizedBox(height: AppSpacing.lg),
            const DailyMessageSection(
              message: '急がなくていい。\n今日の自分に、正直でいられたら。',
              author: '作者名',
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle('今日のステップ'),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontalPadding,
              ),
              child: _buildSteps(),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSteps() {
    final actions = switch (ref.watch(actionsByDateProvider(_selectedDate))) {
      AsyncData(:final value) => value,
      _ => null, // 読み込み中・エラーの時は何も出さない
    };
    if (actions == null) return const SizedBox.shrink();

    final decided = actions.isNotEmpty; // 1つ以上、次の一歩を決めたらSTEP1が完了

    return Column(
      children: [
        StepItem(
          stepNumber: 1,
          title: '次の一歩',
          status: decided ? StepStatus.done : StepStatus.current,
          isFirst: true,
          description: decided
              ? '${actions.length}個の一歩を、自分で決めました。'
              : '理想の自分に近づくために、\n小さな一歩からやることを決めよう',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (decided)
                NextStepSummary(actions: actions)
              else
                AppTextButton(
                  label: '自分の軸を確認する',
                  trailingIcon: AppIcons.chevronRight,
                  onPressed: widget.onOpenAxis,
                ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: decided ? '次の一歩を確認する' : '次の一歩を決める',
                variant: decided
                    ? AppButtonVariant.secondary
                    : AppButtonVariant.primary,
                onPressed: _openNextStep,
              ),
            ],
          ),
        ),
        StepItem(
          stepNumber: 2,
          title: '振り返り',
          status: decided ? StepStatus.current : StepStatus.pending,
          isLast: true,
          description: '自分を振り返って、\n自分の軸を少しずつ育てよう',
          child: AppButton(
            label: '振り返る',
            variant: AppButtonVariant.secondary,
            onPressed: _openReflection,
          ),
        ),
      ],
    );
  }
}
