import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/database/app_database.dart';
import '../utils/date_labels.dart';
import '../utils/date_rules.dart';
import 'action_repository.dart';
import 'reflection_repository.dart';
import 'vision_repository.dart';

class AiHint {
  const AiHint({
    required this.observation,
    required this.question,
    required this.concern,
    required this.remaining,
  });

  final String observation;
  final String question;
  final bool concern; // 心配な内容のとき true（AIの文は空）
  final int remaining; // 今日あと何回受け取れるか
}

// ヒントを受け取れなかった理由
enum AiHintError { limitReached, unavailable, invalidInput, failed }

class AiHintException implements Exception {
  const AiHintException(this.error);

  final AiHintError error;
}

class AiHintRepository {
  AiHintRepository(this._vision, this._actions, this._reflection);

  final VisionRepository _vision;
  final ActionRepository _actions;
  final ReflectionRepository _reflection;

  Future<AiHint> requestHint(DateTime date) async {
    final day = DateRules.dateOnly(date);
    try {
      await _signInIfNeeded();
      final input = await _buildInput(day);

      // 関数は東京に置いたので、場所を合わせる
      final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
          .httpsCallable('getReflectionHint');
      final result = await callable.call(input);
      final data = Map<String, dynamic>.from(result.data as Map);

      return AiHint(
        observation: data['observation'] as String,
        question: data['question'] as String,
        concern: data['concern'] as bool,
        remaining: (data['remaining'] as num).toInt(),
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint('関数のエラー：${e.code} ${e.message}');
      throw AiHintException(switch (e.code) {
        'resource-exhausted' => AiHintError.limitReached,
        'unavailable' => AiHintError.unavailable,
        'invalid-argument' => AiHintError.invalidInput,
        _ => AiHintError.failed,
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('ログインのエラー：${e.code} ${e.message}');
      // 通信できずにログインできなかったときなど
      throw const AiHintException(AiHintError.failed);
    }
  }

  // AIを使うときだけ匿名でログインする（実行回数を数える番号のため）
  Future<void> _signInIfNeeded() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
  }

  // その日の記録を関数が受け付ける形にする。IDなど個人につながる値は入れない
  Future<Map<String, Object>> _buildInput(DateTime day) async {
    final ideals = await _vision.watchIdeals().first;
    final values = await _vision.watchSelectedValues().first;
    final actions = await _actions.watchActionsByDate(day).first;
    final entries = await _reflection.watchEntriesByDate(day).first;
    final note = await _reflection.watchNoteByDate(day).first;

    List<Map<String, Object>> entriesOf(ReflectionKind kind) => [
      for (final item in entries)
        if (item.entry.kind == kind)
          {
            'content': item.entry.content,
            'emotions': [for (final emotion in item.emotions) emotion.label],
          },
    ];

    return {
      'targetDate': _isoDate(day),
      'date': '${DateLabels.monthDay(day)}${DateLabels.weekdayParen(day)}',
      'ideals': [for (final ideal in ideals) ideal.content],
      'values': [for (final value in values) value.name],
      'actions': [
        for (final action in actions)
          {
            'action': action.action,
            'reason': action.reason,
            'status': action.status.name,
            'resultNote': action.resultNote,
          },
      ],
      'good': entriesOf(ReflectionKind.good),
      'discomfort': entriesOf(ReflectionKind.discomfort),
      'note': note?.content ?? '',
    };
  }

  // 例：2026-11-01（サーバーで日付を確かめるときの形）
  String _isoDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}'
      '-${d.day.toString().padLeft(2, '0')}';
}
