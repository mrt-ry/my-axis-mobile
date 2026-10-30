import 'package:flutter/material.dart';
import 'package:my_axis_mobile/repositories/vision_repository.dart';

import '../../repositories/action_repository.dart';
import '../../repositories/vision_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../utils/date_rules.dart';
import '../../widgets/app_button.dart';
import '../../widgets/section_title.dart';
import '../next_step/next_step_screen.dart';
import 'widgets/daily_message_section.dart';
import 'widgets/home_date_header.dart';
import 'widgets/step_item.dart';
import 'widgets/week_strip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.actionRepository,
    required this.visionRepository,
    required this.onOpenAxis,
  });

  final ActionRepository actionRepository;
  final VisionRepository visionRepository;
  final VoidCallback onOpenAxis;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _today = DateRules.today();
  late DateTime _selectedDate = _today;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateUtils.dateOnly(_selectedDate),
      firstDate: DateRules.firstSelectableDate,
      lastDate: DateRules.lastSelectableDate(_today),
    );

    // カレンダー選択のキャンセル、画面がすでに閉じられている場合は中止
    if (picked == null || !mounted) return;
    setState(() {
      _selectedDate = picked;
    });
  }

  void _openNextStep() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NextStepScreen(
          actionRepository: widget.actionRepository,
          visionRepository: widget.visionRepository,
          date: _selectedDate,
          onOpenAxis: widget.onOpenAxis,
        ),
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
              onSelect: (date) => setState(() => _selectedDate = date),
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
              child: Column(
                children: [
                  StepItem(
                    stepNumber: 1,
                    title: '次の一歩',
                    status: StepStatus.current,
                    isFirst: true,
                    description: '理想の自分に近づくために、\n小さな一歩からやることを決めよう',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: widget.onOpenAxis,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size(0, 32),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('自分の軸を確認する'),
                              Icon(AppIcons.chevronRight, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppButton(label: '次の一歩を決める', onPressed: _openNextStep),
                      ],
                    ),
                  ),
                  StepItem(
                    stepNumber: 2,
                    title: '振り返り',
                    status: StepStatus.pending,
                    isLast: true,
                    description: '自分を振り返って、\n自分の軸を少しずつ育てよう',
                    child: AppButton(
                      label: '振り返る',
                      variant: AppButtonVariant.secondary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
