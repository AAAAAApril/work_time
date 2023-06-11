import 'package:work_time/src/beans/enums.dart';
import 'package:work_time/src/repository/abs_repository.dart';
import 'package:work_time/src/repository/cache/shared_preferences_cache.dart';
import 'package:work_time/src/repository/network/dio_network.dart';

///数据层
class Repository extends AbsRepository {
  static final Repository instance = Repository._();

  Repository._();

  final AbsRepository network = DioNetworkRepository();
  final AbsRepository cache = SharedPreferencesCacheRepository();

  @override
  Future<DateTime?> getCheckTime(DateTime day, WorkTimeType type) async {
    DateTime? result = await network.getCheckTime(day, type);
    if (result != null) {
      return result;
    }
    return cache.getCheckTime(day, type);
  }

  @override
  Future<bool> removeCheckTime(DateTime day, WorkTimeType type) async {
    bool result = await network.removeCheckTime(day, type);
    if (result) {
      return result;
    }
    return cache.removeCheckTime(day, type);
  }

  @override
  Future<bool> saveCheckTime(DateTime checkTime, WorkTimeType type) async {
    bool result = await network.saveCheckTime(checkTime, type);
    if (result) {
      return result;
    }
    return cache.saveCheckTime(checkTime, type);
  }
}
