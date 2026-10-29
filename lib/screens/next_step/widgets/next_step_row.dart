import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class NextStepRow extends StatelessWidget {
  const NextStepRow({
    super.key,
    required this.number,
    required this.action,
    required this.reason,
    required this.onEdit,
  });

  final int number;
  final String action;
  final String reason;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number.toString().padLeft(2, '0'),
            style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (reason.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '― $reason',
                    style: AppTypography.emotionalMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: '書き直す',
            icon: const Icon(AppIcons.edit, size: 20),
            color: AppColors.textSecondary,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ],
      ),
    );
  }
}
