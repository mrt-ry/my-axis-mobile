abstract final class DateLabels {
  DateLabels._();

  static const List<String> _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  static String weekday(DateTime date) => _weekdays[date.weekday - 1];

  static String weekdayLong(DateTime date) => '${weekday(date)}曜日';

  static String monthDay(DateTime date) => '${date.month}月${date.day}日';
}
