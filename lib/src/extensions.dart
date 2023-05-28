import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time/src/enums.dart';

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

  String cacheKeyFromType(WorkTimeType type) => '${toYMDString}_${type.name}';

  Future<DateTime?> getCacheByType(WorkTimeType type) {
    return SharedPreferences.getInstance()
        .then<String?>((value) => value.getString(cacheKeyFromType(type)))
        .then<DateTime?>((value) => DateTime.fromMillisecondsSinceEpoch(int.parse(value!)))
        .catchError((_) => null);
  }

  Future<bool> saveTimeByType(WorkTimeType type, DateTime time) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.setString(
        cacheKeyFromType(type),
        time.millisecondsSinceEpoch.toString(),
      );
    });
  }

  Future<bool> removeTimeByType(WorkTimeType type) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.remove(cacheKeyFromType(type));
    });
  }
}
