import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../models/emotion_count.dart';
import '../models/past_reflection.dart';
import '../utils/date_rules.dart';
import 'repository_providers.dart';

/// その月の、気持ちごとのできごとの数（種類ごと、多い順）
final emotionCountsProvider = StreamProvider.autoDispose
    .family<List<EmotionCount>, ({DateTime month, ReflectionKind kind})>((
      ref,
      key,
    ) {
      return ref
          .watch(reflectionRepositoryProvider)
          .watchEmotionCounts(key.month, key.kind);
    });

/// その月に、ある気持ちをつけたできごと（新しい日から）
final entriesByEmotionProvider = StreamProvider.autoDispose
    .family<List<ReflectionEntry>, ({DateTime month, String emotionId})>((
      ref,
      key,
    ) {
      return ref
          .watch(reflectionRepositoryProvider)
          .watchEntriesByEmotion(key.month, key.emotionId);
    });

/// これまでに「できた」一歩の数
final doneCountProvider = StreamProvider.autoDispose<int>((ref) {
  return ref.watch(actionRepositoryProvider).watchDoneCount(DateRules.today());
});

/// 最近「できた」一歩（3つ）
final recentDoneActionsProvider = StreamProvider.autoDispose<List<DailyAction>>(
  (ref) {
    return ref
        .watch(actionRepositoryProvider)
        .watchDoneActions(DateRules.today(), limit: 3);
  },
);

/// これまでに「できた」一歩のすべて（新しい日から）
final doneActionsProvider = StreamProvider.autoDispose<List<DailyAction>>((
  ref,
) {
  return ref
      .watch(actionRepositoryProvider)
      .watchDoneActions(DateRules.today());
});

/// あの頃の自分（アプリを開いている間は、同じものを出す）
final pastReflectionProvider = FutureProvider<PastReflection?>((ref) {
  return ref
      .watch(reflectionRepositoryProvider)
      .pickPastReflection(DateRules.today());
});
