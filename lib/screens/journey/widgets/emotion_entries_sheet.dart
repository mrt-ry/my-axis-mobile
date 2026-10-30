import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../providers/journey_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/date_labels.dart';
import '../../../widgets/app_bottom_sheet.dart';

Future<void> showEmotionEntriesSheet(
  BuildContext context, {
  required DateTime month,
  required Emotion emotion,
  required ValueChanged<DateTime> onOpenDay,
}) {
  return showAppBottomSheet(
    context: context,
    title: '「${emotion.label}」のできごと',
    child: _EmotionEntriesList(
      month: month,
      emotion: emotion,
      onOpenDay: onOpenDay,
    ),
  );
}

class _EmotionEntriesList extends ConsumerWidget {
  const _EmotionEntriesList({
    required this.month,
    required this.emotion,
    required this.onOpenDay,
  });

  final DateTime month;
  final Emotion emotion;
  final ValueChanged<DateTime> onOpenDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (month: month, emotionId: emotion.id);
    final entries = switch (ref.watch(entriesByEmotionProvider(key))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (entries == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${DateLabels.yearMonth(month)}・${entries.length}件',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final entry in entries) ...[
          _EntryCard(
            entry: entry,
            onTap: () {
              // シートを閉じてから、その日の振り返りを開く
              Navigator.of(context).pop();
              onOpenDay(entry.targetDate);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onTap});

  final ReflectionEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.card);

    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateLabels.monthDay(entry.targetDate)} '
                      '${DateLabels.weekdayParen(entry.targetDate)}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.content,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                AppIcons.chevronRight,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
