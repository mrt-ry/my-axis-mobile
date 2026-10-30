import '../data/database/app_database.dart';

class ReflectionEntryWithEmotions {
  const ReflectionEntryWithEmotions({
    required this.entry,
    required this.emotions,
  });

  final ReflectionEntry entry;
  final List<Emotion> emotions;
}
