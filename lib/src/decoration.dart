import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

import 'bean.dart';

class CustomFlexibleTableDecorations extends AbsFlexibleTableDecorations<WeekData> {
  const CustomFlexibleTableDecorations(this.today);

  final DateTime today;

  @override
  Widget? buildBackgroundRowDecoration(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
    int dataIndex,
    WeekData data,
  ) {
    return ColoredBox(
      color: dataIndex.isOdd ? Colors.grey.shade200 : Colors.grey.shade300,
      child: const SizedBox.expand(),
    );
  }

  @override
  Widget? buildForegroundRowDecoration(
    FlexibleTableController<WeekData> controller,
    AbsFlexibleTableConfigurations<WeekData> configurations,
    int dataIndex,
    WeekData data,
  ) {
    Widget child = const SizedBox.expand();
    if (today == data.day) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: Colors.blue,
          ),
        ),
        child: child,
      );
    }
    return IgnorePointer(child: child);
  }
}
