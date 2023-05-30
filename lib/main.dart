import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/extensions.dart';

import 'src/bean.dart';
import 'src/columns.dart';
import 'src/decoration.dart';
import 'src/enums.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkTime',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HostPage(),
    );
  }
}

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {

  ///今天
  final DateTime today = () {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }();

  ///今天的上班时间
  late final DateTime todayStartWorkTime = today.add(WorkTimeType.start.time);

  ///今天的下班时间
  late final DateTime todayEndWorkTime = today.add(WorkTimeType.end.time);

  ///本周
  late final List<DateTime> thisWeek = today.thisWeekDays;

  late FlexibleTableController<WeekData> controller;

  @override
  void initState() {
    super.initState();
    controller = FlexibleTableController<WeekData>();
    refreshHistory();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///刷新打卡历史记录
  Future<void> refreshHistory() async {
    final List<WeekData> data = <WeekData>[];
    for (var element in thisWeek) {
      data.add(
        WeekData(
          element,
          startCheckIn: await element.getCacheByType(WorkTimeType.start),
          endCheckIn: await element.getCacheByType(WorkTimeType.end),
        ),
      );
    }
    controller.value = data;
  }

  ///选择日期
  Future<void> selectData(WeekData data, WorkTimeType type) async {
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
      context: context,
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
    refreshHistory();
  }

  ///删除该数据
  void onDeleteData(WeekData data, WorkTimeType type) {
    data.day.removeTimeByType(type).then((value) {
      refreshHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${thisWeek.first.toYMDString} ~ ${thisWeek.last.toYMDString}'),
      ),
      body: LayoutBuilder(
        builder: (p0, p1) {
          final double itemWidth = p1.maxWidth / 4;
          final FlexibleTableConfigurations<WeekData> configurations = FlexibleTableConfigurations<WeekData>(
            headerRowHeight: 60,
            infoRowHeight: 68,
            pinnedColumns: {
              WeekColumn(
                fixedWidth: itemWidth,
              ),
              CheckInColumn(
                todayStartWorkTime.toHMString,
                fixedWidth: itemWidth,
                type: WorkTimeType.start,
                onInfoPressed: selectData,
                onInfoLongPressed: onDeleteData,
              ),
              CheckInColumn(
                todayEndWorkTime.toHMString,
                fixedWidth: itemWidth,
                type: WorkTimeType.end,
                onInfoPressed: selectData,
                onInfoLongPressed: onDeleteData,
              ),
              TimeOverflowColumn(
                fixedWidth: itemWidth,
              ),
            },
          );
          return Column(
            children: [
              FlexibleTableHeader<WeekData>(
                controller,
                configurations: configurations,
              ),
              Expanded(
                child: FlexibleTableContent<WeekData>(
                  controller,
                  configurations: configurations,
                  decorations: CustomFlexibleTableDecorations(today),
                  additions: FlexibleTableAdditions(
                    fixedFooterHeight: configurations.infoRowHeight,
                    footer: const SizedBox.expand(
                      child: Center(
                        child: Text(
                          '单击添加；长按删除',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
