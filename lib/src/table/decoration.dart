import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';
import 'package:work_time/src/beans/day.dart';

class CustomFlexibleTableDecorations extends AbsFlexibleTableDecorations<Day> {
  const CustomFlexibleTableDecorations(this.today);

  final DateTime today;

  @override
  TableInfoRowDecorationBuilder<Day> get infoRowDecorationBuilder => (arguments, child) {
        return Stack(fit: StackFit.expand, children: [
          ColoredBox(
            color: arguments.dataIndex.isOdd ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
          child,
          if (today == arguments.data.day)
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
        ]);
      };
}
