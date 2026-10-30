import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../models/emotion_count.dart';
import '../../../providers/journey_providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/date_labels.dart';
import '../../../utils/date_rules.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_text_button.dart';
import '../../reflection/reflection_screen.dart';
import 'emotion_entries_sheet.dart';
import 'emotion_rank_row.dart';
import 'journey_section_header.dart';

/// 自分を知る（月ごとの気持ちの傾向）
class EmotionTrendSection extends ConsumerStatefulWidget {
  const EmotionTrendSection({super.key});

  @override
  ConsumerState<EmotionTrendSection> createState() =>
      _EmotionTrendSectionState();
}

class _EmotionTrendSectionState extends ConsumerState<EmotionTrendSection> {
  // はじめに出す数（それより多いときは「ほかの気持ちも見る」で広げる）
  static const _topCount = 3;

  final DateTime _thisMonth = _monthOf(DateRules.today());
  late DateTime _month = _thisMonth;
  // 広げている種類
  final Set<ReflectionKind> _expanded = {};

  static DateTime _monthOf(DateTime date) => DateTime(date.year, date.month);

  bool get _canGoBack =>
      _month.isAfter(_monthOf(DateRules.firstSelectableDate));
  bool get _canGoForward => _month.isBefore(_thisMonth);

  void _moveMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      _expanded.clear();
    });
  }

  void _toggle(ReflectionKind kind) {
    setState(() {
      if (!_expanded.remove(kind)) _expanded.add(kind);
    });
  }

  void _openEntries(Emotion emotion) {
    showEmotionEntriesSheet(
      context,
      month: _month,
      emotion: emotion,
      onOpenDay: _openDay,
    );
  }

  // あゆみタブの中に、その日の振り返りを積む
  void _openDay(DateTime date) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReflectionScreen(date: date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const JourneySectionHeader(
          title: '自分を知る',
          prompt: 'どんな気持ちが多かったかを、見てみよう。',
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildMonthSwitcher(),
        const SizedBox(height: AppSpacing.xs),
        _buildCard(),
      ],
    );
  }

  Widget _buildMonthSwitcher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _canGoBack ? () => _moveMonth(-1) : null,
          tooltip: '前の月',
          icon: const Icon(AppIcons.chevronLeft),
          color: AppColors.primary,
        ),
        Text(
          DateLabels.yearMonth(_month),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _canGoForward ? () => _moveMonth(1) : null,
          tooltip: '次の月',
          icon: const Icon(AppIcons.chevronRight),
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildCard() {
    final good = _watchCounts(ReflectionKind.good);
    final discomfort = _watchCounts(ReflectionKind.discomfort);
    if (good == null || discomfort == null) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (good.isEmpty && discomfort.isEmpty)
            Text(
              'この月は、気持ちのタグをつけた記録がありません。',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          if (good.isNotEmpty) _buildRanking(ReflectionKind.good, good),
          if (good.isNotEmpty && discomfort.isNotEmpty)
            const SizedBox(height: AppSpacing.lg),
          if (discomfort.isNotEmpty)
            _buildRanking(ReflectionKind.discomfort, discomfort),
        ],
      ),
    );
  }

  List<EmotionCount>? _watchCounts(ReflectionKind kind) {
    final key = (month: _month, kind: kind);
    return switch (ref.watch(emotionCountsProvider(key))) {
      AsyncData(:final value) => value,
      _ => null,
    };
  }

  Widget _buildRanking(ReflectionKind kind, List<EmotionCount> counts) {
    final (title, color) = switch (kind) {
      ReflectionKind.good => ('自分らしかったときの気持ち', AppColors.emotionGood),
      ReflectionKind.discomfort => ('違和感のときの気持ち', AppColors.emotionDiscomfort),
    };
    final expanded = _expanded.contains(kind);
    final shown = expanded ? counts : counts.take(_topCount).toList();
    final hiddenCount = counts.length - _topCount;
    final maxCount = counts.first.count;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        for (var i = 0; i < shown.length; i++)
          EmotionRankRow(
            rank: i + 1,
            label: shown[i].emotion.label,
            count: shown[i].count,
            ratio: shown[i].count / maxCount,
            color: color,
            onTap: () => _openEntries(shown[i].emotion),
          ),
        if (hiddenCount > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: AppTextButton(
              label: expanded ? '閉じる' : 'ほかの気持ちも見る（$hiddenCountつ）',
              trailingIcon: expanded
                  ? AppIcons.expandLess
                  : AppIcons.expandMore,
              onPressed: () => _toggle(kind),
            ),
          ),
      ],
    );
  }
}
