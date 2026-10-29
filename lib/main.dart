import 'package:flutter/material.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'repositories/action_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/vision_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final settingsRepository = SettingsRepository(database);
  final onboardingCompleted = await settingsRepository.isOnboardingCompleted();

  runApp(
    App(
      settingsRepository: settingsRepository,
      visionRepository: VisionRepository(database),
      actionRepository: ActionRepository(database),
      showOnboarding: !onboardingCompleted,
    ),
  );
}
