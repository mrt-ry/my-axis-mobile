import 'package:drift/drift.dart';

import '../data/database/app_database.dart';
import '../data/value_candidates.dart';

// 理想の状態・大切にしたい価値観の読み書きを担当
class VisionRepository {
  VisionRepository(this._db);

  final AppDatabase _db;

  static const maxIdeals = 10;
  static const maxValues = 10;
  static const maxIdealLength = 100;

  // ---------- 理想の状態 ----------

  // 登録順で一覧取得
  Stream<List<Ideal>> watchIdeals() {
    return (_db.select(
      _db.ideals,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch();
  }

  // 追加
  Future<bool> addIdeal(String content) async {
    final text = content.trim();
    if (text.isEmpty || text.length > maxIdealLength) return false;

    final current = await _db.select(_db.ideals).get();
    if (current.length >= maxIdeals) return false;

    final now = DateTime.now();
    await _db
        .into(_db.ideals)
        .insert(
          IdealsCompanion.insert(content: text, createdAt: now, updatedAt: now),
        );

    return true;
  }

  // 更新
  Future<bool> updateIdeal(String id, String content) async {
    final text = content.trim();
    if (text.isEmpty || text.length > maxIdealLength) return false;

    await (_db.update(_db.ideals)..where((t) => t.id.equals(id))).write(
      IdealsCompanion(content: Value(text), updatedAt: Value(DateTime.now())),
    );

    return true;
  }

  // 削除
  Future<void> deleteIdeal(String id) async {
    await (_db.delete(_db.ideals)..where((t) => t.id.equals(id))).go();
  }

  // ---------- 大切にしたい価値観 ----------

  // 価値観候補一覧
  List<String> get valueCandidates => valueCandidateNames;

  // 選択した価値観一覧
  Stream<List<SelectedValue>> watchSelectedValues() {
    return (_db.select(
      _db.selectedValues,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).watch();
  }

  // 追加
  Future<bool> addValue(String name) async {
    final text = name.trim();
    if (text.isEmpty) return false;

    final current = await _db.select(_db.selectedValues).get();
    if (current.length >= maxValues) return false;
    if (current.any((v) => v.name == text)) return false;

    final now = DateTime.now();
    await _db
        .into(_db.selectedValues)
        .insert(
          SelectedValuesCompanion.insert(
            name: text,
            createdAt: now,
            updatedAt: now,
          ),
        );

    return true;
  }

  // 削除
  Future<void> deleteValue(String id) async {
    await (_db.delete(_db.selectedValues)..where((t) => t.id.equals(id))).go();
  }
}
