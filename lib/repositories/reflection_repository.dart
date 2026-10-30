import 'package:drift/drift.dart';

import '../data/database/app_database.dart';
import '../models/reflection_entry_with_emotions.dart';
import '../utils/date_rules.dart';

class ReflectionRepository {
  ReflectionRepository(this._db);

  final AppDatabase _db;

  static const maxEntryLength = 100;
  static const maxEmotionsPerEntry = 3;
  static const maxNoteLength = 400;

  // ---------- できごと（自分らしかったこと・違和感） ----------

  // 取得
  Stream<List<ReflectionEntryWithEmotions>> watchEntriesByDate(DateTime date) {
    final day = DateRules.dateOnly(date);
    final entries = _db.reflectionEntries;
    final links = _db.reflectionEntryEmotions;
    final emotions = _db.emotions;

    final query =
        _db.select(entries).join([
            leftOuterJoin(links, links.entryId.equalsExp(entries.id)),
            leftOuterJoin(emotions, emotions.id.equalsExp(links.emotionId)),
          ])
          ..where(entries.targetDate.equals(day))
          ..orderBy([
            OrderingTerm.asc(entries.createdAt),
            OrderingTerm.asc(entries.rowId), // 同じ秒に書いたものは、保存した順に並べる
            OrderingTerm.asc(emotions.sortOrder),
          ]);

    return query.watch().map((rows) {
      final grouped = <String, ReflectionEntryWithEmotions>{};
      for (final row in rows) {
        final entry = row.readTable(entries);
        final emotion = row.readTableOrNull(emotions);
        final item = grouped.putIfAbsent(
          entry.id,
          () => ReflectionEntryWithEmotions(entry: entry, emotions: []),
        );
        if (emotion != null) item.emotions.add(emotion);
      }
      return grouped.values.toList();
    });
  }

  // 追加
  Future<bool> addEntry(
    DateTime date,
    ReflectionKind kind,
    String content,
    List<String> emotionIds,
  ) async {
    final text = content.trim();
    if (!_isValid(text, emotionIds)) return false;

    final now = DateTime.now();
    await _db.transaction(() async {
      final entry = await _db
          .into(_db.reflectionEntries)
          .insertReturning(
            ReflectionEntriesCompanion.insert(
              targetDate: DateRules.dateOnly(date),
              kind: kind,
              content: text,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _insertEmotions(entry.id, emotionIds, now);
    });
    return true;
  }

  // 更新
  Future<bool> updateEntry(
    String id,
    String content,
    List<String> emotionIds,
  ) async {
    final text = content.trim();
    if (!_isValid(text, emotionIds)) return false;

    final now = DateTime.now();
    await _db.transaction(() async {
      await (_db.update(
        _db.reflectionEntries,
      )..where((t) => t.id.equals(id))).write(
        ReflectionEntriesCompanion(content: Value(text), updatedAt: Value(now)),
      );

      await (_db.delete(
        _db.reflectionEntryEmotions,
      )..where((t) => t.entryId.equals(id))).go();
      await _insertEmotions(id, emotionIds, now);
    });

    return true;
  }

  // 削除
  Future<void> deleteEntry(String id) async {
    await (_db.delete(
      _db.reflectionEntries,
    )..where((t) => t.id.equals(id))).go();
  }

  bool _isValid(String text, List<String> emotionIds) {
    return text.isNotEmpty &&
        text.length <= maxEntryLength &&
        emotionIds.length <= maxEmotionsPerEntry;
  }

  Future<void> _insertEmotions(
    String entryId,
    List<String> emotionIds,
    DateTime now,
  ) async {
    for (final emotionId in emotionIds.toSet()) {
      await _db
          .into(_db.reflectionEntryEmotions)
          .insert(
            ReflectionEntryEmotionsCompanion.insert(
              entryId: entryId,
              emotionId: emotionId,
              createdAt: now,
            ),
          );
    }
  }

  // ---------- 気持ちのタグの一覧 ----------

  Future<List<Emotion>> getEmotions(ReflectionKind kind) {
    return (_db.select(_db.emotions)
          ..where((t) => t.kind.equalsValue(kind) & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  // ---------- 気づき ----------

  // 取得
  Stream<ReflectionNote?> watchNoteByDate(DateTime date) {
    final day = DateRules.dateOnly(date);
    return (_db.select(
      _db.reflectionNotes,
    )..where((t) => t.targetDate.equals(day))).watchSingleOrNull();
  }

  // 更新
  Future<bool> saveNote(DateTime date, String content) async {
    final text = content.trim();
    if (text.length > maxNoteLength) return false;

    final day = DateRules.dateOnly(date);
    if (text.isEmpty) {
      await (_db.delete(
        _db.reflectionNotes,
      )..where((t) => t.targetDate.equals(day))).go();
      return true;
    }

    final now = DateTime.now();
    await _db
        .into(_db.reflectionNotes)
        .insert(
          ReflectionNotesCompanion.insert(
            targetDate: day,
            content: text,
            createdAt: now,
            updatedAt: now,
          ),
          onConflict: DoUpdate(
            (old) => ReflectionNotesCompanion(
              content: Value(text),
              updatedAt: Value(now),
            ),
            target: [_db.reflectionNotes.targetDate],
          ),
        );
    return true;
  }
}
