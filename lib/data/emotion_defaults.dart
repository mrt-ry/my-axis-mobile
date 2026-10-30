import 'database/app_database.dart';

// 気持ちのタグ
const emotionDefaults = <({String id, String label, ReflectionKind kind})>[
  // 自分らしかったこと
  (id: 'achievement', label: '達成感', kind: ReflectionKind.good),
  (id: 'happy', label: 'うれしい', kind: ReflectionKind.good),
  (id: 'relieved', label: '安心', kind: ReflectionKind.good),
  (id: 'fun', label: '楽しい', kind: ReflectionKind.good),
  (id: 'grateful', label: '感謝', kind: ReflectionKind.good),
  (id: 'warm', label: 'あたたかい', kind: ReflectionKind.good),
  (id: 'proud', label: '誇らしい', kind: ReflectionKind.good),
  (id: 'excited', label: 'わくわく', kind: ReflectionKind.good),
  (id: 'calm', label: 'おだやか', kind: ReflectionKind.good),

  // 違和感
  (id: 'uneasy', label: 'モヤモヤ', kind: ReflectionKind.discomfort),
  (id: 'anxious', label: '不安', kind: ReflectionKind.discomfort),
  (id: 'impatient', label: '焦り', kind: ReflectionKind.discomfort),
  (id: 'tired', label: '疲れ', kind: ReflectionKind.discomfort),
  (id: 'irritated', label: 'イライラ', kind: ReflectionKind.discomfort),
  (id: 'lonely', label: 'さみしい', kind: ReflectionKind.discomfort),
  (id: 'sad', label: 'かなしい', kind: ReflectionKind.discomfort),
  (id: 'frustrated', label: 'もどかしい', kind: ReflectionKind.discomfort),
  (id: 'nervous', label: '緊張', kind: ReflectionKind.discomfort),
];
