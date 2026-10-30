import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../models/past_reflection.dart';
import '../../../providers/journey_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/date_labels.dart';
import '../../../utils/date_rules.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_text_button.dart';
import '../../../widgets/value_chip.dart';
import '../../reflection/reflection_screen.dart';
import 'journey_section_header.dart';

class PastReflectionSection extends ConsumerWidget {
  const PastReflectionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final past = switch (ref.watch(pastReflectionProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    // 7日以上前の記録がないときは、セクションごと出さない
    if (past == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const JourneySectionHeader(title: 'あの頃の自分', prompt: '少し前の自分に、会いにいく。'),
          const SizedBox(height: AppSpacing.md),
          _PastReflectionCard(
            past: past,
            onOpen: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReflectionScreen(date: past.targetDate),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastReflectionCard extends StatelessWidget {
  const _PastReflectionCard({required this.past, required this.onOpen});

  final PastReflection past;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final date = past.targetDate;
    final daysAgo = DateRules.daysBetween(date, DateRules.today());
    final kindLabel = switch (past.kind) {
      ReflectionKind.good => '自分らしかったこと',
      ReflectionKind.discomfort => '違和感',
      null => '気づき',
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 気持ちのタグと見分けるため、チップにせず文字で出す
              Text(
                '$daysAgo日前',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${DateLabels.monthDay(date)} ${DateLabels.weekdayParen(date)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            kindLabel,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            past.content,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (past.emotions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final emotion in past.emotions)
                  ValueChip(label: emotion.label),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          AppTextButton(
            label: 'この日の振り返りを見る',
            trailingIcon: AppIcons.chevronRight,
            onPressed: onOpen,
          ),
        ],
      ),
    );
  }
}
