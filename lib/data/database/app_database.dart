import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

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

@DriftDatabase(tables: [DailyActions, Ideals, SelectedValues])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'my_axis'));

  @override
  int get schemaVersion => 1;
}
