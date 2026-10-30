import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import 'repository_providers.dart';

/// その日の一歩の一覧（登録順）
final actionsByDateProvider = StreamProvider.autoDispose
    .family<List<DailyAction>, DateTime>((ref, date) {
      return ref.watch(actionRepositoryProvider).watchActionsByDate(date);
    });
