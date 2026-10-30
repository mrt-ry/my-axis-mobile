import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/date_labels.dart';

class DoneStepRow extends StatelessWidget {
  const DoneStepRow({
    super.key,
    required this.action,
    this.showResultNote = false,
  });

  final DailyAction action;
  // 結果のひとことも出すか（すべて見るの画面で出す）
  final bool showResultNote;

  @override
  Widget build(BuildContext context) {
    final date = action.targetDate;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(AppIcons.statusDone, size: 20, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.action,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (showResultNote && action.resultNote.isNotEmpty)
                  Text(
                    '― ${action.resultNote}',
                    style: AppTypography.emotionalMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                Text(
                  '${DateLabels.monthDay(date)} ${DateLabels.weekdayParen(date)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
