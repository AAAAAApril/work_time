import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  static final DateFormat ymdFormatter = DateFormat('yyyy-MM-dd');
  static final DateFormat hmFormatter = DateFormat('HH:mm');

  List<DateTime> get thisWeekDays {
    //今天的星期
    final int nowWeekDay = weekday;
    return List<DateTime>.generate(DateTime.daysPerWeek, (index) {
      final int weekDay = index + 1;
      //今天之前
      if (weekDay < nowWeekDay) {
        return subtract(Duration(days: nowWeekDay - weekDay));
      }
      //今天之后
      else if (weekDay > nowWeekDay) {
        return add(Duration(days: weekDay - nowWeekDay));
      }
      //今天
      else {
        return this;
      }
    }, growable: false);
  }

  String get toYMDString => ymdFormatter.format(this);

  String get toHMString => hmFormatter.format(this);

}
