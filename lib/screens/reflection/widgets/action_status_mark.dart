import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class ActionStatusMark extends StatelessWidget {
  const ActionStatusMark({super.key, required this.status});

  final ActionStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (status) {
      ActionStatus.done => (AppIcons.statusDone, AppColors.primary, 'できた'),
      ActionStatus.notDone => (
        AppIcons.statusNotDone,
        AppColors.textSecondary,
        'できなかった',
      ),
      ActionStatus.unanswered => (
        AppIcons.statusUnanswered,
        AppColors.disabled,
        'まだ',
      ),
    };

    return SizedBox(
      width: 88,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
