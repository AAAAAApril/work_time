import 'package:work_time/src/beans/day.dart';
import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/beans/week.dart';

///数据层抽象类
abstract class AbsRepository {
  const AbsRepository();

  ///获取该周每天的签到数据
  // Future<List<Day>> getDaysOfWeek(Week week);

  ///获取签到时间
  Future<DateTime?> getCheckTime(
    //所属天
    DateTime day,
    //签到类型
    WorkTimeType type,
  );

  ///存储打卡时间
  Future<bool> saveCheckTime(
    //打卡时间
    DateTime checkTime,
    //打卡类型
    WorkTimeType type,
  );

  ///移除打卡时间
  Future<bool> removeCheckTime(
    //所属天
    DateTime day,
    //打卡类型
    WorkTimeType type,
  );
}
