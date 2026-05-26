import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../models/parroquia_info_model.dart';

/// Local data source para información de la parroquia con caché
abstract class ParroquiaLocalDataSource {
  Future<ParroquiaInfoModel?> getCachedInfo();
  Future<void> cacheInfo(ParroquiaInfoModel info);
  Future<void> clearCache();
}

@Injectable(as: ParroquiaLocalDataSource)
class ParroquiaLocalDataSourceImpl implements ParroquiaLocalDataSource {
  final CacheManager cacheManager;
  static const String _cacheKey = 'parroquia_info';
  static const Duration _cacheTTL = Duration(days: 7); // 7 días

  ParroquiaLocalDataSourceImpl(this.cacheManager);

  @override
  Future<ParroquiaInfoModel?> getCachedInfo() async {
    final cachedData = await cacheManager.getData(_cacheKey, ttl: _cacheTTL);

    if (cachedData != null) {
      return ParroquiaInfoModel.fromJson(cachedData);
    }

    return null;
  }

  @override
  Future<void> cacheInfo(ParroquiaInfoModel info) async {
    await cacheManager.saveData(_cacheKey, info.toJson());
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(_cacheKey);
  }
}
