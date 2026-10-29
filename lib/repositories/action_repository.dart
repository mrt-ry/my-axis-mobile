import 'package:drift/drift.dart';

import '../data/database/app_database.dart';
import '../utils/date_rules.dart';

// 次の一歩の読み書きを担当
class ActionRepository {
  ActionRepository(this._db);

  final AppDatabase _db;

  static const maxActionsPerDay = 10;
  static const maxActionLength = 50;
  static const maxReasonLength = 100;

  // 登録順で一覧取得
  Stream<List<DailyAction>> watchActionsByDate(DateTime date) {
    final day = DateRules.dateOnly(date);
    return (_db.select(_db.dailyActions)
          ..where((t) => t.targetDate.equals(day))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  // 追加
  Future<bool> addAction(
    DateTime date,
    String action, {
    String reason = '',
  }) async {
    final text = action.trim();
    if (!_isValid(text, reason)) return false;

    final day = DateRules.dateOnly(date);
    final existing = await (_db.select(
      _db.dailyActions,
    )..where((t) => t.targetDate.equals(day))).get();
    if (existing.length >= maxActionsPerDay) return false;

    final now = DateTime.now();
    await _db
        .into(_db.dailyActions)
        .insert(
          DailyActionsCompanion.insert(
            targetDate: day,
            action: text,
            reason: Value(reason.trim()),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return true;
  }

  // 行動と理由の更新
  Future<bool> updateAction(String id, String action, String reason) async {
    final text = action.trim();
    if (!_isValid(text, reason)) return false;

    await (_db.update(_db.dailyActions)..where((t) => t.id.equals(id))).write(
      DailyActionsCompanion(
        action: Value(text),
        reason: Value(reason.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return true;
  }

  // 実施状況と一言の更新
  Future<void> updateStatus(
    String id,
    ActionStatus status, {
    String resultNote = '',
  }) async {
    await (_db.update(_db.dailyActions)..where((t) => t.id.equals(id))).write(
      DailyActionsCompanion(
        status: Value(status),
        resultNote: Value(resultNote.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 削除
  Future<void> deleteAction(String id) async {
    await (_db.delete(_db.dailyActions)..where((t) => t.id.equals(id))).go();
  }

  bool _isValid(String action, String reason) {
    return action.isNotEmpty &&
        action.length <= maxActionLength &&
        reason.trim().length <= maxReasonLength;
  }
}
