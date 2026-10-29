import 'package:flutter/material.dart';

import '../../repositories/action_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/vision_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_button.dart';
import '../root_screen.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_parts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.settingsRepository,
    required this.visionRepository,
    required this.actionRepository,
  });

  final SettingsRepository settingsRepository;
  final VisionRepository visionRepository;
  final ActionRepository actionRepository;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageCount = 4;
  static const _homeTabIndex = 0;
  static const _axisTabIndex = 1;

  final _controller = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  bool get _isLastPage => _currentPage == _pageCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _goBack() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finish(int tabIndex) async {
    setState(() => _isSaving = true);
    await widget.settingsRepository.completeOnboarding();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RootScreen(
          visionRepository: widget.visionRepository,
          actionRepository: widget.actionRepository,
          initialIndex: tabIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false, // 写真を画面上部まで広げるため
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() {
                  _currentPage = page;
                }),
                children: _buildPages(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontalPadding,
                AppSpacing.sm,
                AppSpacing.screenHorizontalPadding,
                AppSpacing.lg,
              ),
              child: _isLastPage ? _buildLastFooter() : _buildFooter(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      const OnboardingPage(
        pageNumber: 1,
        pageCount: _pageCount,
        photoLabel: '写真：夕方、窓の外を見る人の後ろ姿',
        title: '誰かの正解を、\n自分の正解にしていませんか。',
        body:
            '仕事やSNS、周りの期待の中で。'
            '気づかないうちに、自分の気持ちより、'
            '誰かの基準を優先してしまうことがあります。',
        child: OnboardingInnerVoices(lines: ['これでいいのかな。', 'どう思われるだろう。']),
      ),
      OnboardingPage(
        pageNumber: 2,
        pageCount: _pageCount,
        title: '自分で選ぶ人ほど、\n幸せを感じやすいそうです。',
        body:
            'ある研究では、進学や仕事を自分で決めてきた人ほど、'
            '毎日に満足している傾向があったといいます。',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OnboardingQuote(
              text:
                  'お金や学歴よりも、「自分で決めた」という感覚が、'
                  '幸せと深く関わっていた。',
              source: '西村・八木（2018）経済産業研究所',
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'だから、大切にしたいことを知り、自分で選ぶ毎日を、少しずつ。',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      OnboardingPage(
        pageNumber: 3,
        pageCount: _pageCount,
        title: '自分を知り、\n小さな一歩を重ねる。',
        body: '毎日の中で、こんなことができます。',
        child: OnboardingFeatureList(
          features: [
            OnboardingFeature(
              title: '自分を知る',
              description: '理想の自分と、大切にしたいことを言葉にする。',
            ),
            OnboardingFeature(title: '自分で選ぶ', description: '今日の小さな一歩を、自分で決める。'),
            OnboardingFeature(
              title: 'AIと振り返る',
              description:
                  '記録をもとに、自分を知るヒントを受け取る。'
                  '使うかどうかは、あなたが決められます。',
            ),
            OnboardingFeature(
              title: 'あゆみから気づく',
              description: '積み重ねた記録から、変化に気づく。',
            ),
          ],
        ),
      ),
      OnboardingPage(
        pageNumber: 4,
        pageCount: _pageCount,
        photoLabel: '写真：朝の窓辺の机、開いたノートとペン',
        title: 'まずは、\n大切にしたいことから。',
        body:
            '正解はありません。今の気持ちを、あなたの言葉で。'
            'あとから、いつでも書き直せます。',
      ),
    ];
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _currentPage > 0
            ? AppTextButton(
                label: '戻る',
                leadingIcon: AppIcons.chevronLeft,
                onPressed: _goBack,
              )
            : const SizedBox.shrink(),
        AppTextButton(
          label: '次へ',
          trailingIcon: AppIcons.chevronRight,
          onPressed: _goNext,
        ),
      ],
    );
  }

  Widget _buildLastFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: '理想・価値観を書いてみる',
          isLoading: _isSaving,
          onPressed: () => _finish(_axisTabIndex),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTextButton(
              label: '戻る',
              leadingIcon: AppIcons.chevronLeft,
              onPressed: _isSaving ? null : _goBack,
            ),
            AppTextButton(
              label: 'あとで設定する',
              onPressed: _isSaving ? null : () => _finish(_homeTabIndex),
            ),
          ],
        ),
      ],
    );
  }
}
