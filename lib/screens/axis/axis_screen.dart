import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/vision_providers.dart';
import '../../repositories/vision_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state_box.dart';
import '../../widgets/numbered_edit_row.dart';
import '../../widgets/section_title.dart';
import '../../widgets/value_chip.dart';
import 'widgets/ideal_edit_sheet.dart';
import 'widgets/value_select_sheet.dart';

class AxisScreen extends ConsumerStatefulWidget {
  const AxisScreen({super.key});

  @override
  ConsumerState<AxisScreen> createState() => _AxisScreenState();
}

class _AxisScreenState extends ConsumerState<AxisScreen> {
  void _addIdeal(int currentCount) {
    if (currentCount >= VisionRepository.maxIdeals) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '理想の状態は${VisionRepository.maxIdeals}個までです。入れ替える時は、どれかを削除してください。',
          ),
        ),
      );
      return;
    }
    showIdealEditSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      '自分の軸',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'どんな自分で、いたいですか？',
                    style: AppTypography.emotionalMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle('理想の状態'),
            const SizedBox(height: AppSpacing.md),
            _buildIdeals(),
            const SizedBox(height: AppSpacing.xl),
            const SectionTitle('大切にしたい価値観'),
            const SizedBox(height: AppSpacing.md),
            _buildValues(),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeals() {
    final ideals = switch (ref.watch(idealsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (ideals == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (ideals.isEmpty)
            const EmptyStateBox(
              message: 'どんな自分でありたいか、ひとつ書いてみませんか？',
              example: '例：家族と穏やかに過ごしている自分',
            )
          else
            for (var i = 0; i < ideals.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sm),
              NumberedEditRow(
                number: i + 1,
                text: ideals[i].content,
                onEdit: () => showIdealEditSheet(context, ideal: ideals[i]),
              ),
            ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: '理想の状態を追加する',
            variant: AppButtonVariant.secondary,
            onPressed: () => _addIdeal(ideals.length),
          ),
        ],
      ),
    );
  }

  Widget _buildValues() {
    final values = switch (ref.watch(selectedValuesProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (values == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (values.isEmpty)
            const EmptyStateBox(
              message: '大切にしたいことを、選んでみましょう。',
              example: '例：挑戦、つながり、自由、成長、感謝',
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [for (final v in values) ValueChip(label: v.name)],
            ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: values.isEmpty ? '価値観を選ぶ' : '編集する',
            variant: AppButtonVariant.secondary,
            onPressed: () => showValueSelectSheet(context, current: values),
          ),
        ],
      ),
    );
  }
}
