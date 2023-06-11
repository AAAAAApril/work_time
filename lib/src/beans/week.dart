import 'package:work_time/src/extensions/date_time_extension.dart';

///每周 数据结构
class Week {
  Week(this.focusDay);

  ///焦点日期，与今天的星期相同的那天
  final DateTime focusDay;

  ///焦点日期所在的那一周
  late final List<DateTime> weekDays = focusDay.thisWeekDays;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Week && runtimeType == other.runtimeType && focusDay == other.focusDay;

  @override
  int get hashCode => focusDay.hashCode;
}
