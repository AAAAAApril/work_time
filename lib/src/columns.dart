import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/enums.dart';
import 'package:work_time/src/extensions.dart';

import 'bean.dart';

///星期列
class WeekColumn extends AbsFlexibleColumn<WeekData> {
  const WeekColumn({
    required this.fixedWidth,
  }) : super('本周');

  @override
  final double fixedWidth;

  @override
  Widget buildHeader(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
  ) {
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
  Widget buildInfo(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
    int dataIndex,
    WeekData data,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.weekDay.dayName,
            style: TextStyle(
              color: data.weekDay.checkInEnableStateTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.day.toYMDString,
            style: TextStyle(
              color: data.weekDay.checkInEnableStateTextColor,
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
    required this.fixedWidth,
    required this.type,
    required this.onInfoPressed,
    required this.onInfoLongPressed,
  }) : super(title);

  final String title;
  @override
  final double fixedWidth;
  final WorkTimeType type;
  final void Function(WeekData data, WorkTimeType type) onInfoPressed;
  final void Function(WeekData data, WorkTimeType type) onInfoLongPressed;

  @override
  Widget buildHeader(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
  ) {
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
  Widget buildInfo(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
    int dataIndex,
    WeekData data,
  ) {
    final String infoText;
    final String subInfoText;
    final Color infoColor;
    switch (type) {
      case WorkTimeType.start:
        infoText = data.startCheckInText;
        if (data.startCheckInOverflow == null) {
          subInfoText = '-';
        } else {
          subInfoText = '${data.startCheckInOverflow!.inMinutes}分钟';
        }
        infoColor = data.startCheckIn == null
            ? Colors.grey
            : data.isAfterStart
                ? Colors.red
                : Colors.green;
        break;
      case WorkTimeType.end:
        infoText = data.endCheckInText;
        if (data.endCheckInOverflow == null) {
          subInfoText = '-';
        } else {
          subInfoText = '${data.endCheckInOverflow!.inMinutes}分钟';
        }
        infoColor = data.endCheckIn == null
            ? Colors.grey
            : data.isBeforeEnd
                ? Colors.red
                : Colors.green;
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: data.weekDay.checkInEnable ? () => onInfoPressed.call(data, type) : null,
      onLongPress: data.weekDay.checkInEnable ? () => onInfoLongPressed.call(data, type) : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: dataIndex.isOdd ? Colors.grey.shade300 : Colors.white54,
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
    required this.fixedWidth,
  }) : super('超出');

  @override
  final double fixedWidth;

  @override
  Widget buildHeader(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
  ) {
    return Center(
      child: ValueListenableBuilder<List<WeekData>>(
        valueListenable: controller,
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
  Widget buildInfo(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
    int dataIndex,
    WeekData data,
  ) {
    final Duration? overflowDuration = data.workOverflow;
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