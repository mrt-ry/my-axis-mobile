import 'package:flutter/material.dart';

import '../../../models/reflection_entry_with_emotions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/value_chip.dart';

class ReflectionEntryCard extends StatelessWidget {
  const ReflectionEntryCard({
    super.key,
    required this.item,
    required this.onEdit,
  });

  final ReflectionEntryWithEmotions item;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.entry.content,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (item.emotions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final emotion in item.emotions)
                          ValueChip(label: emotion.label),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: '編集',
            icon: const Icon(AppIcons.edit, size: 20),
            color: AppColors.textSecondary,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ),
    );
  }
}
