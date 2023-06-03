import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/enums.dart';
import 'package:work_time/src/extensions.dart';

import 'bean.dart';

///星期列
class WeekColumn extends AbsFlexibleColumn<WeekData> {
  const WeekColumn({
    required this.columnWidth,
  }) : super('本周');

  @override
  final AbsFlexibleTableColumnWidth columnWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<WeekData> arguments) {
    return Center(
      child: Text(
        id,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<WeekData> arguments) {
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
class CheckInColumn extends AbsFlexibleColumn<WeekData> {
  const CheckInColumn(
    this.title, {
    required this.columnWidth,
    required this.type,
    required this.onInfoPressed,
    required this.onInfoLongPressed,
  }) : super(title);

  final String title;
  @override
  final AbsFlexibleTableColumnWidth columnWidth;
  final WorkTimeType type;
  final void Function(WeekData data, WorkTimeType type) onInfoPressed;
  final void Function(WeekData data, WorkTimeType type) onInfoLongPressed;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<WeekData> arguments) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<WeekData> arguments) {
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
      onTap: () => onInfoPressed.call(arguments.data, type),
      onLongPress: () => onInfoLongPressed.call(arguments.data, type),
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
class TimeOverflowColumn extends AbsFlexibleColumn<WeekData> {
  const TimeOverflowColumn({
    required this.columnWidth,
  }) : super('超出');

  @override
  final AbsFlexibleTableColumnWidth columnWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<WeekData> arguments) {
    return Center(
      child: ValueListenableBuilder<List<WeekData>>(
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
  Widget buildInfoCell(TableInfoRowBuildArguments<WeekData> arguments) {
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
