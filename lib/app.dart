import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'repositories/action_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/vision_repository.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/root_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.settingsRepository,
    required this.visionRepository,
    required this.actionRepository,
    required this.showOnboarding,
  });

  final SettingsRepository settingsRepository;
  final VisionRepository visionRepository;
  final ActionRepository actionRepository;
  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Axis',
      theme: AppTheme.light,
      locale: const Locale('ja'),
      supportedLocales: const [Locale('ja')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: showOnboarding
          ? OnboardingScreen(
              settingsRepository: settingsRepository,
              visionRepository: visionRepository,
              actionRepository: actionRepository,
            )
          : RootScreen(
              visionRepository: visionRepository,
              actionRepository: actionRepository,
            ),
    );
  }
}
