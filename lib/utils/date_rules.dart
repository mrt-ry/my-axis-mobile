abstract final class DateRules {
  DateRules._();

  static final DateTime firstSelectableDate = DateTime(2026);

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime lastSelectableDate(DateTime today) =>
      DateTime(today.year, today.month, today.day + 1);

  static DateTime today() => dateOnly(DateTime.now());

  static int daysBetween(DateTime from, DateTime to) {
    final start = DateTime.utc(from.year, from.month, from.day);
    final end = DateTime.utc(to.year, to.month, to.day);
    return end.difference(start).inDays;
  }
}
