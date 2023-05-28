import 'package:flutter/material.dart';

enum WorkTimeType {
  //上班
  start,
  //下班
  end,
}

enum WeekDay {
  monday(1, '周一'),
  tuesday(2, '周二'),
  wednesday(3, '周三'),
  thursday(4, '周四'),
  friday(5, '周五'),
  saturday(6, '周六'),
  sunday(7, '周日');

  const WeekDay(this.value, this.dayName);

  final int value;
  final String dayName;
}

extension WeekDayExt on WeekDay {
  bool get checkInEnable => value < WeekDay.saturday.value;

  Color get checkInEnableStateTextColor => checkInEnable ? Colors.blue : Colors.grey;
}

extension IterableWeekDayExt on Iterable<WeekDay> {
  WeekDay fromValue(int value) => firstWhere((element) => element.value == value);
}
