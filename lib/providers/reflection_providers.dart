import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import '../models/reflection_entry_with_emotions.dart';
import 'action_providers.dart';
import 'repository_providers.dart';

final reflectionEntriesByDateProvider = StreamProvider.autoDispose
    .family<List<ReflectionEntryWithEmotions>, DateTime>((ref, date) {
      return ref.watch(reflectionRepositoryProvider).watchEntriesByDate(date);
    });

final reflectionNoteByDateProvider = StreamProvider.autoDispose
    .family<ReflectionNote?, DateTime>((ref, date) {
      return ref.watch(reflectionRepositoryProvider).watchNoteByDate(date);
    });

final emotionsProvider = FutureProvider.family<List<Emotion>, ReflectionKind>((
  ref,
  kind,
) {
  return ref.watch(reflectionRepositoryProvider).getEmotions(kind);
});

final reflectionRecordedProvider = Provider.autoDispose.family<bool?, DateTime>(
  (ref, date) {
    final actions = ref.watch(actionsByDateProvider(date));
    final entries = ref.watch(reflectionEntriesByDateProvider(date));
    final note = ref.watch(reflectionNoteByDateProvider(date));
    if (!actions.hasValue || !entries.hasValue || !note.hasValue) return null;

    // どれか1つでも残していれば、記録済み
    return actions.value!.any((a) => a.status != ActionStatus.unanswered) ||
        entries.value!.isNotEmpty ||
        note.value != null;
  },
);
