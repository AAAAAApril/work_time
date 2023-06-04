import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/extensions.dart';
import 'package:work_time/src/record_page.dart';

import 'src/bean.dart';
import 'src/columns.dart';
import 'src/decoration.dart';

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
        //不使用 Material3
        useMaterial3: false,
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

  ///正在显示的周
  late ValueNotifier<Week> showingWeek;

  late FlexibleTableConfigurations<WeekData> configurations;
  late CustomFlexibleTableDecorations decorations;
  late FlexibleTableAdditions<WeekData> additions;

  @override
  void initState() {
    super.initState();
    showingWeek = ValueNotifier<Week>(Week(today));
    configurations = FlexibleTableConfigurations<WeekData>(
      rowHeight: const FixedHeight(
        headerRowHeight: 60,
        fixedInfoRowHeight: 80,
      ),
      pinnedColumns: {
        WeekColumn(
          Week(today),
          showWeek: showingWeek,
          onHeaderPressed: () => showingWeek.value = Week(today),
        ),
        CheckInColumn.start(),
        CheckInColumn.end(),
        const TimeOverflowColumn(),
      },
    );
    decorations = CustomFlexibleTableDecorations(today);
    additions = FlexibleTableAdditions(
      fixedFooterHeight: configurations.rowHeight.fixedInfoRowHeight,
      footer: const SizedBox.expand(
        child: Text(
          '单击添加；长按删除；左右箭头切换星期；点击本周回到当前周',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    showingWeek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          //上一周
          leading: ValueListenableBuilder<Week>(
            valueListenable: showingWeek,
            builder: (context, value, child) {
              //超过5周，则不再显示按钮
              if (today.difference(value.focusDay).inDays > (DateTime.daysPerWeek * 5)) {
                return const SizedBox.shrink();
              }
              return IconButton(
                onPressed: () {
                  showingWeek.value = Week(
                    showingWeek.value.focusDay.subtract(
                      const Duration(days: DateTime.daysPerWeek),
                    ),
                  );
                },
                icon: child!,
              );
            },
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
          actions: [
            //下一周
            ValueListenableBuilder<Week>(
              valueListenable: showingWeek,
              builder: (context, value, child) {
                //超过3周，则不再显示按钮
                if (value.focusDay.difference(today).inDays > (DateTime.daysPerWeek * 3)) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  onPressed: () {
                    showingWeek.value = Week(
                      showingWeek.value.focusDay.add(
                        const Duration(days: DateTime.daysPerWeek),
                      ),
                    );
                  },
                  icon: child!,
                );
              },
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
          title: ValueListenableBuilder<Week>(
            valueListenable: showingWeek,
            builder: (context, value, child) => Text(
              '${value.weekDays.first.toYMDString} ~ ${value.weekDays.last.toYMDString}',
            ),
          ),
        ),
        body: ScrollConfiguration(
          behavior: const NoOverscrollScrollBehavior(),
          child: ValueListenableBuilder<Week>(
            valueListenable: showingWeek,
            builder: (context, value, child) => RecordPage(
              week: value,
              configurations: configurations,
              decorations: decorations,
              additions: additions,
            ),
          ),
        ),
      ),
    );
  }
}
