import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers/repository_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runAppの前に設定を読み込むため、providerの入れ物を先に作成
  final container = ProviderContainer();
  final onboardingCompleted = await container
      .read(settingsRepositoryProvider)
      .isOnboardingCompleted();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: App(showOnboarding: !onboardingCompleted),
    ),
  );
}
