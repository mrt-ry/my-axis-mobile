import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'providers/repository_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseと接続
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 本物のアプリかを確認。開発中は開発用の照明を使用。
  await FirebaseAppCheck.instance.activate(
    providerApple: kDebugMode
        ? const AppleDebugProvider(
            debugToken: String.fromEnvironment('APP_CHECK_DEBUG_TOKEN'),
          )
        : const AppleAppAttestProvider(),
  );

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
