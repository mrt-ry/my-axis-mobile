import '../data/database/app_database.dart';

/// あの頃の自分に出す、過去の記録1つ
class PastReflection {
  const PastReflection({
    required this.targetDate,
    required this.kind,
    required this.content,
    required this.emotions,
  });

  final DateTime targetDate;
  // 自分らしかったこと・違和感。気づきのときは null
  final ReflectionKind? kind;
  final String content;
  final List<Emotion> emotions;
}
