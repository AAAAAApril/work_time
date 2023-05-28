import 'package:work_time/src/enums.dart';

import 'extensions.dart';

///数据实体
class WeekData {
  WeekData(
    this.day, {
    this.startCheckIn,
    this.endCheckIn,
  });

  ///当天
  final DateTime day;

  ///实际上班打卡时间
  final DateTime? startCheckIn;

  ///实际下班打卡时间
  final DateTime? endCheckIn;

  ///当天所属的星期
  late final WeekDay weekDay = WeekDay.values.fromValue(day.weekday);

  ///当天的上班时间
  late final startWorkTime = DateTime(day.year, day.month, day.day).add(WorkTimeType.start.time);

  ///当天的下班时间
  late final endWorkTime = DateTime(day.year, day.month, day.day).add(WorkTimeType.end.time);

  ///是否在上班之后打卡
  late final bool isAfterStart = () {
    if (startCheckIn == null) {
      return false;
    }
    return startCheckIn!.isAfter(startWorkTime);
  }();

  ///是否在下班之前打卡
  late final bool isBeforeEnd = () {
    if (endCheckIn == null) {
      return false;
    }
    return endCheckIn!.isBefore(endWorkTime);
  }();

  ///上班打卡多出的时间
  late final Duration? startCheckInOverflow = () {
    if (startCheckIn == null) {
      return null;
    }
    return startWorkTime.difference(startCheckIn!);
  }();

  ///下班打卡多出的时间
  late final Duration? endCheckInOverflow = () {
    if (endCheckIn == null) {
      return null;
    }
    return endCheckIn!.difference(endWorkTime);
  }();

  ///上班打卡时间文字
  late final String startCheckInText = startCheckIn?.toHMString ?? '-';

  ///下班打卡时间文字
  late final String endCheckInText = endCheckIn?.toHMString ?? '-';

  ///每天多出来的上班时间
  late final Duration? workOverflow = () {
    //当天还没有打卡
    if (startCheckInOverflow == null && endCheckInOverflow == null) {
      return null;
    }
    //上下班都打卡了
    else if (startCheckInOverflow != null && endCheckInOverflow != null) {
      return endCheckInOverflow! + startCheckInOverflow!;
    }
    //其中一个卡打了
    else {
      if (startCheckInOverflow != null) {
        return startCheckInOverflow;
      } else {
        return endCheckInOverflow;
      }
    }
  }();

  WeekData copyWith({
    DateTime? startCheckIn,
    DateTime? endCheckIn,
  }) =>
      WeekData(
        day,
        startCheckIn: startCheckIn ?? this.startCheckIn,
        endCheckIn: endCheckIn ?? this.endCheckIn,
      );
}
