import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/beans/day.dart';
import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/beans/week.dart';
import 'package:work_time/src/repository.dart';
import 'package:work_time/src/repository/abs_repository.dart';

///记录表控制器
class RecordTableController extends FlexibleTableController<Day> {
  RecordTableController(
    this.thisWeek, {
    required this.contextGetter,
  }) {
    refresh();
  }

  final AbsRepository repository = Repository.instance;

  ///表数据所属周
  final Week thisWeek;
  final ValueGetter<BuildContext> contextGetter;

  ///刷新记录
  void refresh() async {
    final List<Day> data = <Day>[];
    for (var element in thisWeek.weekDays) {
      data.add(
        Day(
          element,
          startCheckIn: await repository.getCheckTime(element, WorkTimeType.start),
          endCheckIn: await repository.getCheckTime(element, WorkTimeType.end),
        ),
      );
    }
    value = data;
  }

  ///选择数据
  void onSelectDate(Day data, WorkTimeType type) async {
    DateTime? nowTime;
    switch (type) {
      case WorkTimeType.start:
        nowTime = data.startCheckIn;
        break;
      case WorkTimeType.end:
        nowTime = data.endCheckIn;
        break;
    }
    nowTime ??= DateTime.now();
    //显示时间选择弹窗
    final TimeOfDay? selectTime = await showTimePicker(
      context: contextGetter.call(),
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: nowTime.hour,
        minute: nowTime.minute,
      ),
    );
    if (selectTime == null) {
      return;
    }
    final DateTime thatDay = data.day;
    //存起来
    await repository.saveCheckTime(
      DateTime(
        thatDay.year,
        thatDay.month,
        thatDay.day,
        selectTime.hour,
        selectTime.minute,
      ),
      type,
    );
    //刷新记录
    refresh();
  }

  ///删除该数据
  void onDeleteDate(Day data, WorkTimeType type) {
    repository.removeCheckTime(data.day, type).then((value) {
      refresh();
    });
  }
}
