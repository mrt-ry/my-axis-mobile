import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_card.dart';

enum StepStatus { pending, current, done }

const double _markerSize = 24;

class StepItem extends StatelessWidget {
  const StepItem({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.status,
    required this.description,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
  });

  final int stepNumber;
  final String title;
  final StepStatus status;
  final String description;
  final Widget child;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final emphasized = status == StepStatus.current;
    final topGap = emphasized ? AppSpacing.lg : 0.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP $stepNumber',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _markerSize,
            child: Column(
              children: [
                isFirst
                    ? SizedBox(height: topGap)
                    : Container(
                        width: 2,
                        height: topGap,
                        color: AppColors.border,
                      ),
                _StepMarker(status: status),
                if (!isLast)
                  Expanded(child: Container(width: 2, color: AppColors.border)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
              child: emphasized ? AppCard(child: content) : content,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.status});

  final StepStatus status;

  @override
  Widget build(BuildContext context) {
    final isCurrent = status == StepStatus.current;
    final isDone = status == StepStatus.done;

    final background = isDone ? AppColors.primaryTint : Colors.transparent;

    final borderColor = isDone
        ? AppColors.primaryTint
        : isCurrent
        ? AppColors.primary
        : AppColors.textSecondary;

    return Container(
      width: _markerSize,
      height: _markerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: isDone
          ? Icon(AppIcons.check, size: 18, color: AppColors.onPrimaryTint)
          : isCurrent
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }
}
