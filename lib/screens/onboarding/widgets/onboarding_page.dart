import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.pageNumber,
    required this.pageCount,
    required this.title,
    required this.body,
    this.photoLabel,
    this.child,
  });

  final int pageNumber;
  final int pageCount;
  final String title;
  final String body;
  final String? photoLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoLabel != null;
    final topPadding = hasPhoto
        ? AppSpacing.xl
        : MediaQuery.paddingOf(context).top + AppSpacing.xxl;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasPhoto) _PhotoPlaceholder(label: photoLabel!),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontalPadding,
              topPadding,
              AppSpacing.screenHorizontalPadding,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: '$pageCountページ中$pageNumberページ目',
                  excludeSemantics: true,
                  child: Text(
                    '${_twoDigits(pageNumber)} / ${_twoDigits(pageCount)}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppTypography.emotionalLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  body,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (child != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  child!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      color: AppColors.border,
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
