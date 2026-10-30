import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart';
import 'repository_providers.dart';

final idealsProvider = StreamProvider<List<Ideal>>((ref) {
  return ref.watch(visionRepositoryProvider).watchIdeals();
});

final selectedValuesProvider = StreamProvider<List<SelectedValue>>((ref) {
  return ref.watch(visionRepositoryProvider).watchSelectedValues();
});
