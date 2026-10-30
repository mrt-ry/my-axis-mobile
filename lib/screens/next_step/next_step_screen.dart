import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/database/app_database.dart';
import '../../repositories/action_repository.dart';
import '../../repositories/vision_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/date_labels.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_button.dart';
import 'widgets/ideal_quote.dart';
import 'widgets/next_step_edit_sheet.dart';
import 'widgets/next_step_row.dart';

class NextStepScreen extends StatefulWidget {
  const NextStepScreen({
    super.key,
    required this.actionRepository,
    required this.visionRepository,
    required this.date,
    required this.onOpenAxis,
  });

  final ActionRepository actionRepository;
  final VisionRepository visionRepository;
  final DateTime date;
  final VoidCallback onOpenAxis;

  @override
  State<NextStepScreen> createState() => _NextStepScreenState();
}

class _NextStepScreenState extends State<NextStepScreen> {
  late final Stream<List<DailyAction>> _actionStream = widget.actionRepository
      .watchActionsByDate(widget.date);
  late final Future<String?> _idealText = _pickIdeal();

  Future<String?> _pickIdeal() async {
    final ideals = await widget.visionRepository.watchIdeals().first;
    if (ideals.isEmpty) return null;
    return ideals[Random().nextInt(ideals.length)].content;
  }

  void _openAxis() {
    Navigator.of(context).pop();
    widget.onOpenAxis();
  }

  void _addAction(int currentCount) {
    if (currentCount >= ActionRepository.maxActionsPerDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '1日に選べる一歩は${ActionRepository.maxActionsPerDay}個までです。入れ替える時は、どれかを削除してください。',
          ),
        ),
      );
      return;
    }
    _openSheet();
  }

  void _openSheet([DailyAction? action]) {
    showNextStepEditSheet(
      context,
      repository: widget.actionRepository,
      date: widget.date,
      action: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontalPadding,
            AppSpacing.sm,
            AppSpacing.screenHorizontalPadding,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              '${DateLabels.monthDay(widget.date)} '
              '${DateLabels.weekdayParen(widget.date)}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              header: true,
              child: Text(
                '今日の自分に、\nどんな一歩を選ぶ？',
                style: AppTypography.emotionalTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildIdeal(),
            AppTextButton(
              label: '自分の軸をすべて見る',
              trailingIcon: AppIcons.chevronRight,
              onPressed: _openAxis,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeal() {
    return FutureBuilder<String?>(
      future: _idealText,
      builder: (context, snapshot) {
        final text = snapshot.data;
        if (text == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: IdealQuote(text: text),
        );
      },
    );
  }

  Widget _buildActions() {
    return StreamBuilder<List<DailyAction>>(
      stream: _actionStream,
      builder: (context, snapshot) {
        final actions = snapshot.data;
        if (actions == null) return const SizedBox.shrink();

        if (actions.isEmpty) {
          return _EmptyNextStep(onAdd: () => _addAction(0));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < actions.length; i++)
                    NextStepRow(
                      number: i + 1,
                      action: actions[i].action,
                      reason: actions[i].reason,
                      onEdit: () => _openSheet(actions[i]),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextButton(
              label: '一歩を加える',
              leadingIcon: AppIcons.add,
              onPressed: () => _addAction(actions.length),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'どれも、あなたが自分で選んだ一歩です。',
              style: AppTypography.emotionalMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyNextStep extends StatelessWidget {
  const _EmptyNextStep({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '大きなことでなくて、いい。\n理想の自分なら、今日何をするだろう。',
          style: AppTypography.emotionalMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '例：10分だけ早く寝る / 家族に電話する',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: '一歩を選ぶ', onPressed: onAdd),
      ],
    );
  }
}
