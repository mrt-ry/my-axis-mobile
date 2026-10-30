import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../providers/journey_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/date_labels.dart';
import '../../widgets/app_card.dart';
import 'widgets/done_step_row.dart';

/// できた一歩のすべて（月ごと、新しい日から）
class DoneStepsScreen extends ConsumerWidget {
  const DoneStepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = switch (ref.watch(doneActionsProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };

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
            Semantics(
              header: true,
              child: Text(
                '積み重ねた一歩',
                style: AppTypography.emotionalTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (actions != null)
              for (final group in _groupByMonth(actions)) ...[
                Text(
                  DateLabels.yearMonth(group.month),
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < group.actions.length; i++) ...[
                        if (i > 0)
                          const Divider(height: 1, color: AppColors.border),
                        DoneStepRow(
                          action: group.actions[i],
                          showResultNote: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
          ],
        ),
      ),
    );
  }

  // 新しい日から並んだ一覧を、月ごとのかたまりに分ける
  List<({DateTime month, List<DailyAction> actions})> _groupByMonth(
    List<DailyAction> actions,
  ) {
    final groups = <({DateTime month, List<DailyAction> actions})>[];
    for (final action in actions) {
      final month = DateTime(action.targetDate.year, action.targetDate.month);
      if (groups.isEmpty || groups.last.month != month) {
        groups.add((month: month, actions: []));
      }
      groups.last.actions.add(action);
    }
    return groups;
  }
}
