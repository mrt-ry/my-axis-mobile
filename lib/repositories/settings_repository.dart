import '../data/database/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  static const _onboardingCompletedKey = 'onboarding_completed';

  // オンボーディングが済んでいるか
  Future<bool> isOnboardingCompleted() async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(_onboardingCompletedKey))).getSingleOrNull();

    return row?.value == 'true';
  }

  // オンボーディング済みを記録する
  Future<void> completeOnboarding() async {
    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _onboardingCompletedKey,
            value: 'true',
          ),
        );
  }
}
