import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_card.dart';
import 'action_status_mark.dart';

class ActionResultCard extends StatelessWidget {
  const ActionResultCard({
    super.key,
    required this.action,
    required this.onEdit,
  });

  final DailyAction action;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Row(
        children: [
          ActionStatusMark(status: action.status),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.action,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (action.resultNote.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '― ${action.resultNote}',
                      style: AppTypography.emotionalMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
