import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

enum ActionStatus { unanswered, done, notDone }

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

@DriftDatabase(tables: [DailyActions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'my_axis'));

  @override
  int get schemaVersion => 1;
}
