import 'dart:math';

import 'package:drift/drift.dart';

import '../data/database/app_database.dart';
import '../models/emotion_count.dart';
import '../models/past_reflection.dart';
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
  // ---------- あゆみ ----------

  // その月の、気持ちごとのできごとの数（多い順。同じ数なら一覧の並び順）
  Stream<List<EmotionCount>> watchEmotionCounts(
    DateTime month,
    ReflectionKind kind,
  ) {
    final (start, end) = _monthRange(month);
    final entries = _db.reflectionEntries;
    final links = _db.reflectionEntryEmotions;
    final emotions = _db.emotions;
    final count = links.entryId.count();

    final query =
        _db.select(emotions).join([
            innerJoin(
              links,
              links.emotionId.equalsExp(emotions.id),
              useColumns: false,
            ),
            innerJoin(
              entries,
              entries.id.equalsExp(links.entryId),
              useColumns: false,
            ),
          ])
          ..addColumns([count])
          ..where(
            entries.targetDate.isBiggerOrEqualValue(start) &
                entries.targetDate.isSmallerThanValue(end) &
                entries.kind.equalsValue(kind),
          )
          ..groupBy([emotions.id])
          ..orderBy([
            OrderingTerm.desc(count),
            OrderingTerm.asc(emotions.sortOrder),
          ]);

    return query.watch().map(
      (rows) => [
        for (final row in rows)
          EmotionCount(
            emotion: row.readTable(emotions),
            count: row.read(count)!,
          ),
      ],
    );
  }

  // その月に、ある気持ちをつけたできごと（新しい日から）
  Stream<List<ReflectionEntry>> watchEntriesByEmotion(
    DateTime month,
    String emotionId,
  ) {
    final (start, end) = _monthRange(month);
    final entries = _db.reflectionEntries;
    final links = _db.reflectionEntryEmotions;

    final query =
        _db.select(entries).join([
            innerJoin(
              links,
              links.entryId.equalsExp(entries.id),
              useColumns: false,
            ),
          ])
          ..where(
            links.emotionId.equals(emotionId) &
                entries.targetDate.isBiggerOrEqualValue(start) &
                entries.targetDate.isSmallerThanValue(end),
          )
          ..orderBy([
            OrderingTerm.desc(entries.targetDate),
            OrderingTerm.asc(entries.createdAt),
            OrderingTerm.asc(entries.rowId),
          ]);

    return query.watch().map(
      (rows) => [for (final row in rows) row.readTable(entries)],
    );
  }

  // 7日以上前の、できごと・気づきから1つを選ぶ（なければ null）
  Future<PastReflection?> pickPastReflection(DateTime today) async {
    final day = DateRules.dateOnly(today);
    final cutoff = DateTime(day.year, day.month, day.day - 7);
    final entries = _db.reflectionEntries;
    final notes = _db.reflectionNotes;

    final entryIds =
        await (_db.selectOnly(entries)
              ..addColumns([entries.id])
              ..where(entries.targetDate.isSmallerOrEqualValue(cutoff)))
            .map((row) => row.read(entries.id)!)
            .get();
    final noteIds =
        await (_db.selectOnly(notes)
              ..addColumns([notes.id])
              ..where(notes.targetDate.isSmallerOrEqualValue(cutoff)))
            .map((row) => row.read(notes.id)!)
            .get();

    final total = entryIds.length + noteIds.length;
    if (total == 0) return null;

    // できごとと気づきを1つの列に並べたと考えて、その中から1つ選ぶ
    final index = Random().nextInt(total);
    if (index < entryIds.length) {
      return _pastEntry(entryIds[index]);
    }

    final note = await (_db.select(
      notes,
    )..where((t) => t.id.equals(noteIds[index - entryIds.length]))).getSingle();
    return PastReflection(
      targetDate: note.targetDate,
      kind: null,
      content: note.content,
      emotions: const [],
    );
  }

  Future<PastReflection> _pastEntry(String id) async {
    final entries = _db.reflectionEntries;
    final links = _db.reflectionEntryEmotions;
    final emotions = _db.emotions;

    final rows =
        await (_db.select(entries).join([
                leftOuterJoin(links, links.entryId.equalsExp(entries.id)),
                leftOuterJoin(emotions, emotions.id.equalsExp(links.emotionId)),
              ])
              ..where(entries.id.equals(id))
              ..orderBy([OrderingTerm.asc(emotions.sortOrder)]))
            .get();

    final entry = rows.first.readTable(entries);
    return PastReflection(
      targetDate: entry.targetDate,
      kind: entry.kind,
      content: entry.content,
      emotions: [for (final row in rows) ?row.readTableOrNull(emotions)],
    );
  }

  // その月の1日と、次の月の1日
  (DateTime, DateTime) _monthRange(DateTime month) {
    return (
      DateTime(month.year, month.month),
      DateTime(month.year, month.month + 1),
    );
  }
}
