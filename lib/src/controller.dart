import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/extensions.dart';

import 'bean.dart';
import 'enums.dart';

///记录表控制器
class RecordTableController extends FlexibleTableController<WeekData> {
  RecordTableController(
    this.thisWeek, {
    required this.contextGetter,
  }) {
    refresh();
  }

  ///表数据所属周
  final Week thisWeek;
  final ValueGetter<BuildContext> contextGetter;

  ///刷新记录
  void refresh() async {
    final List<WeekData> data = <WeekData>[];
    for (var element in thisWeek.weekDays) {
      data.add(
        WeekData(
          element,
          startCheckIn: await element.getCacheByType(WorkTimeType.start),
          endCheckIn: await element.getCacheByType(WorkTimeType.end),
        ),
      );
    }
    value = data;
  }

  ///选择数据
  void onSelectDate(WeekData data, WorkTimeType type) async {
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
    thatDay.saveTimeByType(
      type,
      DateTime(
        thatDay.year,
        thatDay.month,
        thatDay.day,
        selectTime.hour,
        selectTime.minute,
      ),
    );
    //刷新记录
    refresh();
  }

  ///删除该数据
  void onDeleteDate(WeekData data, WorkTimeType type) {
    data.day.removeTimeByType(type).then((value) {
      refresh();
    });
  }
}
