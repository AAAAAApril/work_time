import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/extensions/date_time_extension.dart';
import 'package:work_time/src/repository/abs_repository.dart';

/// [SharedPreferences] 实现的缓存层
class SharedPreferencesCacheRepository extends AbsRepository {
  String _cacheKeyFromType(DateTime day, WorkTimeType type) => '${day.toYMDString}_${type.name}';

  ///获取签到时间
  @override
  Future<DateTime?> getCheckTime(
    //所属天
    DateTime day,
    //签到类型
    WorkTimeType type,
  ) {
    return SharedPreferences.getInstance()
        .then<String?>((value) => value.getString(_cacheKeyFromType(day, type)))
        .then<DateTime?>((value) => DateTime.fromMillisecondsSinceEpoch(int.parse(value!)))
        .catchError((_) => null);
  }

  ///存储打卡时间
  @override
  Future<bool> saveCheckTime(
    //打卡时间
    DateTime checkTime,
    //打卡类型
    WorkTimeType type,
  ) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.setString(
        _cacheKeyFromType(checkTime, type),
        checkTime.millisecondsSinceEpoch.toString(),
      );
    });
  }

  ///移除打卡时间
  @override
  Future<bool> removeCheckTime(
    //所属天
    DateTime day,
    //打卡类型
    WorkTimeType type,
  ) {
    return SharedPreferences.getInstance().then<bool>((value) {
      return value.remove(_cacheKeyFromType(day, type));
    });
  }

  ///移除上班打卡时间
  Future<bool> removeCheckInTime(DateTime day) => removeCheckTime(day, WorkTimeType.start);
}
