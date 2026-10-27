import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class DailyMessageSection extends StatelessWidget {
  const DailyMessageSection({super.key, required this.message, this.author});

  final String message;
  final String? author;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontalPadding,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.messageBackground,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今日のことば',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.messageSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.emotionalMedium.copyWith(
              color: AppColors.messageText,
            ),
          ),
          if (author != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 1,
                  color: AppColors.messageSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  author!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.messageSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
