import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// 記録の保存について（プライバシーの説明）
class StorageInfoScreen extends StatelessWidget {
  const StorageInfoScreen({super.key});

  // 文言は仮。AIの振り返り（Day 3.5）を入れたら、送るときの説明を足す
  static const _paragraphs = [
    'あなたが書いた記録（理想・価値観・一歩・振り返り）は、このiPhoneの中にだけ保存されます。',
    '記録を外部のサーバーに送ることはありません。アプリの運営者を含め、ほかの人が読むことはありません。',
    'アプリを削除すると、記録も一緒に消えます。いまは、別の端末へ記録を引き継ぐことはできません。',
  ];

  @override
  Widget build(BuildContext context) {
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
                '記録の保存について',
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final text in _paragraphs) ...[
              Text(
                text,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}
