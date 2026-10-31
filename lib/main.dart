import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'providers/repository_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseと接続
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
