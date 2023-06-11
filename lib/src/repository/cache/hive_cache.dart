import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/repository/abs_repository.dart';

/// [Hive] 实现的缓存层
class HiveCacheRepository extends AbsRepository {
  @override
  Future<DateTime?> getCheckTime(DateTime day, WorkTimeType type) {
    // TODO: implement getCheckTime
    throw UnimplementedError();
  }

  @override
  Future<bool> removeCheckTime(DateTime day, WorkTimeType type) {
    // TODO: implement removeCheckTime
    throw UnimplementedError();
  }

  @override
  Future<bool> saveCheckTime(DateTime checkTime, WorkTimeType type) {
    // TODO: implement saveCheckTime
    throw UnimplementedError();
  }
}
