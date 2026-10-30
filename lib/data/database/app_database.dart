import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import '../emotion_defaults.dart';

part 'app_database.g.dart';

// 次の一歩の実施状況
enum ActionStatus { unanswered, done, notDone }

// 次の一歩
class DailyActions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get targetDate => dateTime()();
  TextColumn get action => text()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  TextColumn get status =>
      textEnum<ActionStatus>().withDefault(const Constant('unanswered'))();
  TextColumn get resultNote => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 理想の状態
class Ideals extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 価値観
class SelectedValues extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// アプリ設定
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// 振り返りのできごとの種類（自分らしかったこと・違和感）
enum ReflectionKind { good, discomfort }

@TableIndex(name: 'reflection_entries_target_date', columns: {#targetDate})
class ReflectionEntries extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get targetDate => dateTime()();
  TextColumn get kind => textEnum<ReflectionKind>()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Emotions extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get kind => textEnum<ReflectionKind>()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'reflection_entry_emotions_emotion', columns: {#emotionId})
class ReflectionEntryEmotions extends Table {
  TextColumn get entryId =>
      text().references(ReflectionEntries, #id, onDelete: KeyAction.cascade)();
  TextColumn get emotionId => text().references(Emotions, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {entryId, emotionId};
}

class ReflectionNotes extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  DateTimeColumn get targetDate => dateTime().unique()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    DailyActions,
    Ideals,
    SelectedValues,
    AppSettings,
    ReflectionEntries,
    Emotions,
    ReflectionEntryEmotions,
    ReflectionNotes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'my_axis'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // 親（できごと）を消したら、つないだタグも消えるようにする
      await customStatement('PRAGMA foreign_keys = ON');
      await _syncEmotions();
    },
  );

  Future<void> _syncEmotions() async {
    await batch((b) {
      b.insertAllOnConflictUpdate(emotions, [
        for (final (i, e) in emotionDefaults.indexed)
          EmotionsCompanion.insert(
            id: e.id,
            label: e.label,
            kind: e.kind,
            sortOrder: i,
            isActive: const Value(true),
          ),
      ]);
    });

    final ids = emotionDefaults.map((e) => e.id);
    await (update(emotions)..where((t) => t.id.isNotIn(ids))).write(
      const EmotionsCompanion(isActive: Value(false)),
    );
  }
}
