import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/beans/day.dart';
import 'package:work_time/src/beans/week.dart';
import 'package:work_time/src/table/controller.dart';

///打卡记录界面
class RecordPage extends StatefulWidget {
  const RecordPage({
    super.key,
    required this.week,
    required this.configurations,
    required this.decorations,
    required this.additions,
  });

  ///记录所属周
  final Week week;

  ///配置项
  final AbsFlexibleTableConfigurations<Day> configurations;

  ///装饰器
  final AbsFlexibleTableDecorations<Day> decorations;

  ///附加组件
  final AbsFlexibleTableAdditions<Day> additions;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late RecordTableController controller;

  @override
  void initState() {
    super.initState();
    controller = RecordTableController(widget.week, contextGetter: getContext);
  }

  @override
  void didUpdateWidget(covariant RecordPage oldWidget) {
    if (widget.week != oldWidget.week) {
      controller.dispose();
      controller = RecordTableController(widget.week, contextGetter: getContext);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  BuildContext getContext() => context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlexibleTableHeader<Day>(
          controller,
          configurations: widget.configurations,
        ),
        Expanded(
          child: FlexibleTableContent<Day>(
            controller,
            configurations: widget.configurations,
            decorations: widget.decorations,
            additions: widget.additions,
          ),
        ),
      ],
    );
  }
}
