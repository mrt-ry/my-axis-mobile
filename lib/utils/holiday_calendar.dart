import 'package:holiday_jp/holiday_jp.dart' as holiday_jp;

abstract final class HolidayCalendar {
  HolidayCalendar._();

  static String? nameOf(DateTime date) {
    return holiday_jp.getHoliday(date)?.name;
  }
}
