abstract final class DateLabels {
  DateLabels._();

  static const List<String> _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  static String weekday(DateTime date) => _weekdays[date.weekday - 1];

  static String weekdayParen(DateTime date) => '(${weekday(date)})';

  static String monthDay(DateTime date) => '${date.month}月${date.day}日';

  static String yearMonth(DateTime date) => '${date.year}年${date.month}月';
}
