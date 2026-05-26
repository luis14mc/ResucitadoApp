import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../models/oficina_info_model.dart';

abstract class OficinaLocalDataSource {
  Future<OficinaInfoModel?> getCachedInfo();
  Future<void> cacheInfo(OficinaInfoModel info);
  Future<void> clearCache();
}

@Injectable(as: OficinaLocalDataSource)
class OficinaLocalDataSourceImpl implements OficinaLocalDataSource {
  final CacheManager cacheManager;
  static const String _cacheKey = 'oficina_info';
  static const Duration _cacheTTL = Duration(days: 7);

  OficinaLocalDataSourceImpl(this.cacheManager);

  @override
  Future<OficinaInfoModel?> getCachedInfo() async {
    final cachedData = await cacheManager.getData(_cacheKey, ttl: _cacheTTL);
    if (cachedData != null) {
      return OficinaInfoModel.fromJson(cachedData);
    }
    return null;
  }

  @override
  Future<void> cacheInfo(OficinaInfoModel info) async {
    await cacheManager.saveData(_cacheKey, info.toJson());
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(_cacheKey);
  }
}
