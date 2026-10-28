// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyActionsTable extends DailyActions
    with TableInfo<$DailyActionsTable, DailyAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unanswered'),
      ).withConverter<ActionStatus>($DailyActionsTable.$converterstatus);
  static const VerificationMeta _resultNoteMeta = const VerificationMeta(
    'resultNote',
  );
  @override
  late final GeneratedColumn<String> resultNote = GeneratedColumn<String>(
    'result_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetDate,
    action,
    reason,
    status,
    resultNote,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('result_note')) {
      context.handle(
        _resultNoteMeta,
        resultNote.isAcceptableOrUnknown(data['result_note']!, _resultNoteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: $DailyActionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      resultNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyActionsTable createAlias(String alias) {
    return $DailyActionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActionStatus, String, String> $converterstatus =
      const EnumNameConverter<ActionStatus>(ActionStatus.values);
}

class DailyAction extends DataClass implements Insertable<DailyAction> {
  final String id;
  final DateTime targetDate;
  final String action;
  final String reason;
  final ActionStatus status;
  final String resultNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyAction({
    required this.id,
    required this.targetDate,
    required this.action,
    required this.reason,
    required this.status,
    required this.resultNote,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['action'] = Variable<String>(action);
    map['reason'] = Variable<String>(reason);
    {
      map['status'] = Variable<String>(
        $DailyActionsTable.$converterstatus.toSql(status),
      );
    }
    map['result_note'] = Variable<String>(resultNote);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyActionsCompanion toCompanion(bool nullToAbsent) {
    return DailyActionsCompanion(
      id: Value(id),
      targetDate: Value(targetDate),
      action: Value(action),
      reason: Value(reason),
      status: Value(status),
      resultNote: Value(resultNote),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyAction(
      id: serializer.fromJson<String>(json['id']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      action: serializer.fromJson<String>(json['action']),
      reason: serializer.fromJson<String>(json['reason']),
      status: $DailyActionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      resultNote: serializer.fromJson<String>(json['resultNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'action': serializer.toJson<String>(action),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(
        $DailyActionsTable.$converterstatus.toJson(status),
      ),
      'resultNote': serializer.toJson<String>(resultNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyAction copyWith({
    String? id,
    DateTime? targetDate,
    String? action,
    String? reason,
    ActionStatus? status,
    String? resultNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyAction(
    id: id ?? this.id,
    targetDate: targetDate ?? this.targetDate,
    action: action ?? this.action,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    resultNote: resultNote ?? this.resultNote,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyAction copyWithCompanion(DailyActionsCompanion data) {
    return DailyAction(
      id: data.id.present ? data.id.value : this.id,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      action: data.action.present ? data.action.value : this.action,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      resultNote: data.resultNote.present
          ? data.resultNote.value
          : this.resultNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyAction(')
          ..write('id: $id, ')
          ..write('targetDate: $targetDate, ')
          ..write('action: $action, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetDate,
    action,
    reason,
    status,
    resultNote,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyAction &&
          other.id == this.id &&
          other.targetDate == this.targetDate &&
          other.action == this.action &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.resultNote == this.resultNote &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyActionsCompanion extends UpdateCompanion<DailyAction> {
  final Value<String> id;
  final Value<DateTime> targetDate;
  final Value<String> action;
  final Value<String> reason;
  final Value<ActionStatus> status;
  final Value<String> resultNote;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyActionsCompanion({
    this.id = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.action = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime targetDate,
    required String action,
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.resultNote = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : targetDate = Value(targetDate),
       action = Value(action),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyAction> custom({
    Expression<String>? id,
    Expression<DateTime>? targetDate,
    Expression<String>? action,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<String>? resultNote,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetDate != null) 'target_date': targetDate,
      if (action != null) 'action': action,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (resultNote != null) 'result_note': resultNote,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? targetDate,
    Value<String>? action,
    Value<String>? reason,
    Value<ActionStatus>? status,
    Value<String>? resultNote,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyActionsCompanion(
      id: id ?? this.id,
      targetDate: targetDate ?? this.targetDate,
      action: action ?? this.action,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      resultNote: resultNote ?? this.resultNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DailyActionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (resultNote.present) {
      map['result_note'] = Variable<String>(resultNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActionsCompanion(')
          ..write('id: $id, ')
          ..write('targetDate: $targetDate, ')
          ..write('action: $action, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyActionsTable dailyActions = $DailyActionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dailyActions];
}

typedef $$DailyActionsTableCreateCompanionBuilder =
    DailyActionsCompanion Function({
      Value<String> id,
      required DateTime targetDate,
      required String action,
      Value<String> reason,
      Value<ActionStatus> status,
      Value<String> resultNote,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyActionsTableUpdateCompanionBuilder =
    DailyActionsCompanion Function({
      Value<String> id,
      Value<DateTime> targetDate,
      Value<String> action,
      Value<String> reason,
      Value<ActionStatus> status,
      Value<String> resultNote,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyActionsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyActionsTable> {
  $$DailyActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActionStatus, ActionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyActionsTable> {
  $$DailyActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyActionsTable> {
  $$DailyActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyActionsTable,
          DailyAction,
          $$DailyActionsTableFilterComposer,
          $$DailyActionsTableOrderingComposer,
          $$DailyActionsTableAnnotationComposer,
          $$DailyActionsTableCreateCompanionBuilder,
          $$DailyActionsTableUpdateCompanionBuilder,
          (
            DailyAction,
            BaseReferences<_$AppDatabase, $DailyActionsTable, DailyAction>,
          ),
          DailyAction,
          PrefetchHooks Function()
        > {
  $$DailyActionsTableTableManager(_$AppDatabase db, $DailyActionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<ActionStatus> status = const Value.absent(),
                Value<String> resultNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActionsCompanion(
                id: id,
                targetDate: targetDate,
                action: action,
                reason: reason,
                status: status,
                resultNote: resultNote,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required DateTime targetDate,
                required String action,
                Value<String> reason = const Value.absent(),
                Value<ActionStatus> status = const Value.absent(),
                Value<String> resultNote = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyActionsCompanion.insert(
                id: id,
                targetDate: targetDate,
                action: action,
                reason: reason,
                status: status,
                resultNote: resultNote,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyActionsTable, DailyAction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyActionsTable,
                    DailyAction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyActionsTable,
      DailyAction,
      $$DailyActionsTableFilterComposer,
      $$DailyActionsTableOrderingComposer,
      $$DailyActionsTableAnnotationComposer,
      $$DailyActionsTableCreateCompanionBuilder,
      $$DailyActionsTableUpdateCompanionBuilder,
      (
        DailyAction,
        BaseReferences<_$AppDatabase, $DailyActionsTable, DailyAction>,
      ),
      DailyAction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyActionsTableTableManager get dailyActions =>
      $$DailyActionsTableTableManager(_db, _db.dailyActions);
}
