import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'widgets/done_step_section.dart';
import 'widgets/emotion_trend_section.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontalPadding,
            AppSpacing.xl,
            AppSpacing.screenHorizontalPadding,
            AppSpacing.xxl,
          ),
          children: [
            Semantics(
              header: true,
              child: Text(
                'これまでの自分を、\nながめてみる。',
                style: AppTypography.emotionalTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const EmotionTrendSection(),
            const SizedBox(height: AppSpacing.xxl),
            const DoneStepsSection(),
          ],
        ),
      ),
    );
  }
}
