import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_info_providers.dart';
import '../../providers/repository_providers.dart';
import '../../repositories/ai_hint_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../utils/date_rules.dart';
import '../onboarding/onboarding_screen.dart';
import 'storage_info_screen.dart';
import 'widgets/settings_group.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = switch (ref.watch(appVersionProvider)) {
      AsyncData(:final value) => value,
      _ => '',
    };

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
                '設定',
                style: AppTypography.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SettingsGroup(
              title: 'このアプリについて',
              rows: [
                SettingsRow(
                  label: 'はじめの説明をもう一度見る',
                  // 写真を画面いっぱいに出すため、下のナビゲーションの上に重ねて開く
                  onTap: () => Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) =>
                          const OnboardingScreen(isReview: true),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SettingsGroup(
              title: 'プライバシー',
              rows: [
                SettingsRow(
                  label: '記録の保存について',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StorageInfoScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            SettingsGroup(
              title: 'アプリの情報',
              rows: [SettingsRow(label: 'バージョン', value: version)],
            ),
            if (kDebugMode)
              TextButton(
                onPressed: () async {
                  try {
                    final hint = await ref
                        .read(aiHintRepositoryProvider)
                        .requestHint(DateRules.today());
                    debugPrint('見えたこと：${hint.observation}');
                    debugPrint(
                      '問い：${hint.question}／心配：${hint.concern}／残り：${hint.remaining}',
                    );
                  } on AiHintException catch (e) {
                    debugPrint('受け取れませんでした：${e.error}');
                  }
                },
                child: const Text('AIのテスト（開発用）'),
              ),
          ],
        ),
      ),
    );
  }
}
