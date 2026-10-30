import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/action_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/date_labels.dart';
import 'widgets/action_result_card.dart';
import 'widgets/action_result_sheet.dart';
import 'widgets/reflection_section_header.dart';

class ReflectionScreen extends ConsumerWidget {
  const ReflectionScreen({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontalPadding,
            AppSpacing.sm,
            AppSpacing.screenHorizontalPadding,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              '${DateLabels.monthDay(date)} ${DateLabels.weekdayParen(date)}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              header: true,
              child: Text(
                '今日の自分を、\nふりかえってみる。',
                style: AppTypography.emotionalTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildActions(context, ref),
          ],
        ),
      ),
    );
  }

  // 01 次の一歩
  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final actions = switch (ref.watch(actionsByDateProvider(date))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (actions == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReflectionSectionHeader(
          number: 1,
          title: '次の一歩',
          prompt: '今日の一歩は、どうでしたか？',
          countLabel: actions.isEmpty ? null : '${actions.length}個',
        ),
        const SizedBox(height: AppSpacing.md),
        if (actions.isEmpty)
          Text(
            'この日は、一歩を決めていません。',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            ActionResultCard(
              action: actions[i],
              onEdit: () => showActionResultSheet(context, action: actions[i]),
            ),
          ],
      ],
    );
  }
}
