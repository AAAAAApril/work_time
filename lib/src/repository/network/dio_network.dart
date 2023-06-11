import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/repository/abs_repository.dart';

/// [Dio] 实现的网络数据层
class DioNetworkRepository extends AbsRepository {
  @override
  Future<DateTime?> getCheckTime(DateTime day, WorkTimeType type) async {
    // TODO: implement getCheckTime
    return null;
  }

  @override
  Future<bool> removeCheckTime(DateTime day, WorkTimeType type) async {
    // TODO: implement removeCheckTime
    return false;
  }

  @override
  Future<bool> saveCheckTime(DateTime checkTime, WorkTimeType type) async {
    // TODO: implement saveCheckTime
    return false;
  }
}
