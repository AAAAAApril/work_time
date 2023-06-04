import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

import 'bean.dart';
import 'controller.dart';

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
  final AbsFlexibleTableConfigurations<WeekData> configurations;

  ///装饰器
  final AbsFlexibleTableDecorations<WeekData> decorations;

  ///附加组件
  final AbsFlexibleTableAdditions<WeekData> additions;

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
        FlexibleTableHeader<WeekData>(
          controller,
          configurations: widget.configurations,
        ),
        Expanded(
          child: FlexibleTableContent<WeekData>(
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
