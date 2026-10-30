import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/journey_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_text_button.dart';
import '../done_steps_screen.dart';
import 'done_step_row.dart';
import 'journey_section_header.dart';

/// 積み重ねた一歩（できた一歩の合計と、最近のもの）
class DoneStepsSection extends ConsumerWidget {
  const DoneStepsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JourneySectionHeader(title: '積み重ねた一歩', prompt: '自分で選んで、できたこと。'),
        const SizedBox(height: AppSpacing.md),
        _buildCard(context, ref),
      ],
    );
  }

  Widget _buildCard(BuildContext context, WidgetRef ref) {
    final count = switch (ref.watch(doneCountProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final recent = switch (ref.watch(recentDoneActionsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (count == null || recent == null) return const SizedBox.shrink();

    // 0件のときは、0という数字を出さない
    if (count == 0) {
      return AppCard(
        child: Text(
          '振り返りで「できた」と答えた一歩が、ここに積み重なっていきます。',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$count',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '個の一歩が、できました',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.xs),
          for (final action in recent) DoneStepRow(action: action),
          Align(
            alignment: Alignment.centerLeft,
            child: AppTextButton(
              label: 'すべて見る',
              trailingIcon: AppIcons.chevronRight,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DoneStepsScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
