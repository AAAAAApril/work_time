import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time/src/enums.dart';

extension DateTimeExt on DateTime {
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
    });
  }

  String get toYMDHMString {
    return DateFormat('yyyy-MM-dd HH:mm').format(this);
  }

  String get toYMDString {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get toHMString {
    return DateFormat('HH:mm').format(this);
  }

  Future<DateTime?> getCacheByType(WorkTimeType type) {
    return SharedPreferences.getInstance()
        .then<String?>((value) => value.getString('${toYMDString}_${type.name}'))
        .then<DateTime?>((value) => DateTime.fromMillisecondsSinceEpoch(int.parse(value!)))
        .catchError((_) => null);
  }

  Future<bool> saveTimeByType(WorkTimeType type, DateTime time) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.setString(
        '${toYMDString}_${type.name}',
        time.millisecondsSinceEpoch.toString(),
      );
    });
  }

  Future<bool> removeTimeByType(WorkTimeType type) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.remove('${toYMDString}_${type.name}');
    });
  }
}

extension NullableDurationExt on Duration? {
  String get balanceText {
    return '-';
  }
}
