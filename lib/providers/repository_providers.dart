import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../repositories/action_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/vision_repository.dart';

// アプリで使用する共通DB
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

final visionRepositoryProvider = Provider<VisionRepository>((ref) {
  return VisionRepository(ref.watch(databaseProvider));
});

final actionRepositoryProvider = Provider<ActionRepository>((ref) {
  return ActionRepository(ref.watch(databaseProvider));
});
