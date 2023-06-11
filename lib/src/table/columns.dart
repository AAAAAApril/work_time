import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/beans/day.dart';
import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/beans/week.dart';
import 'package:work_time/src/extensions/date_time_extension.dart';
import 'package:work_time/src/table/controller.dart';

///星期列
class WeekColumn extends AbsFlexibleColumn<Day> {
  WeekColumn(
    this.weekOfToday, {
    required this.showWeek,
    required this.onHeaderPressed,
  }) : super('本周');

  final Week weekOfToday;
  final ValueListenable<Week> showWeek;
  final VoidCallback onHeaderPressed;

  @override
  AbsFlexibleTableColumnWidth get columnWidth => ProportionalWidth(1 / 4);

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<Day> arguments) {
    return ValueListenableBuilder<Week>(
      valueListenable: showWeek,
      builder: (context, value, child) {
        final bool thisWeek = weekOfToday == showWeek.value;
        Widget child = SizedBox.expand(
          child: Center(
            child: Text(
              id,
              style: TextStyle(
                //正在显示的不是这周，文字使用蓝色，表示可以点击
                color: thisWeek ? Colors.black : Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        );
        //正在显示的是这周，不需要点击事件
        if (thisWeek) {
          return child;
        }
        return GestureDetector(
          onTap: onHeaderPressed,
          child: child,
        );
      },
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<Day> arguments) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            arguments.data.weekDay.dayName,
            style: TextStyle(
              color: arguments.data.weekDay.checkInEnableStateTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            arguments.data.day.toYMDString,
            style: TextStyle(
              color: arguments.data.weekDay.checkInEnableStateTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

///签到打卡 列
class CheckInColumn extends AbsFlexibleColumn<Day> {
  CheckInColumn(this.type) : super(type.name);

  CheckInColumn.start() : this(WorkTimeType.start);

  CheckInColumn.end() : this(WorkTimeType.end);

  final WorkTimeType type;

  @override
  AbsFlexibleTableColumnWidth get columnWidth => ProportionalWidth(1 / 4);

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<Day> arguments) {
    final DateTime today = DateTime.now();
    return Center(
      child: Text(
        DateTime(
          today.year,
          today.month,
          today.day,
        ).add(type.time).toHMString,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<Day> arguments) {
    final String infoText;
    final String subInfoText;
    final Color infoColor;
    switch (type) {
      case WorkTimeType.start:
        infoText = arguments.data.startCheckInText;
        if (arguments.data.startCheckInOverflow == null) {
          subInfoText = '-';
        } else {
          subInfoText = '${arguments.data.startCheckInOverflow!.inMinutes}分钟';
        }
        infoColor = arguments.data.startCheckIn == null
            ? Colors.grey
            : arguments.data.isAfterStart
                ? Colors.red
                : Colors.green;
        break;
      case WorkTimeType.end:
        infoText = arguments.data.endCheckInText;
        if (arguments.data.endCheckInOverflow == null) {
          subInfoText = '-';
        } else {
          subInfoText = '${arguments.data.endCheckInOverflow!.inMinutes}分钟';
        }
        infoColor = arguments.data.endCheckIn == null
            ? Colors.grey
            : arguments.data.isBeforeEnd
                ? Colors.red
                : Colors.green;
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => (arguments.controller as RecordTableController).onSelectDate(arguments.data, type),
      onLongPress: () => (arguments.controller as RecordTableController).onDeleteDate(arguments.data, type),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: arguments.dataIndex.isOdd ? Colors.grey.shade300 : Colors.white54,
          shape: BoxShape.circle,
        ),
        child: SizedBox.expand(
          child: Align(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                infoText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: infoColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subInfoText,
                style: TextStyle(
                  fontSize: 10,
                  color: infoColor,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

///超时 列
class TimeOverflowColumn extends AbsFlexibleColumn<Day> {
  const TimeOverflowColumn() : super('超出');

  @override
  AbsFlexibleTableColumnWidth get columnWidth => ProportionalWidth(1 / 4);

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<Day> arguments) {
    return Center(
      child: ValueListenableBuilder<List<Day>>(
        valueListenable: arguments.controller,
        builder: (context, value, child) {
          final Duration totalWorkflowTime = value.fold<Duration>(
            Duration.zero,
            (previousValue, element) => previousValue + (element.workOverflow ?? Duration.zero),
          );
          return Text(
            '${totalWorkflowTime.inMinutes}分钟',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: totalWorkflowTime.isNegative ? Colors.red : Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<Day> arguments) {
    final Duration? overflowDuration = arguments.data.workOverflow;
    final String text;
    final Color textColor;
    if (overflowDuration == null) {
      text = '-';
      textColor = Colors.grey;
    } else {
      text = '${overflowDuration.inMinutes}分钟';
      textColor = overflowDuration.isNegative ? Colors.red : Colors.green;
    }
    return Align(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
