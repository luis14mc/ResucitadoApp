import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../models/emision_model.dart';

/// Local data source para emisiones con caché
abstract class EmisionesLocalDataSource {
  Future<List<EmisionModel>?> getCachedEmisiones();
  Future<void> cacheEmisiones(List<EmisionModel> emisiones);
  Future<void> clearCache();
}

@Injectable(as: EmisionesLocalDataSource)
class EmisionesLocalDataSourceImpl implements EmisionesLocalDataSource {
  final CacheManager cacheManager;
  static const String _cacheKey = 'emisiones_activas';
  static const Duration _cacheTTL = Duration(hours: 6); // 6 horas

  EmisionesLocalDataSourceImpl(this.cacheManager);

  @override
  Future<List<EmisionModel>?> getCachedEmisiones() async {
    final cachedData = await cacheManager.getData(
      _cacheKey,
      ttl: _cacheTTL,
    );

    if (cachedData != null && cachedData['emisiones'] != null) {
      final List<dynamic> emisionesJson = cachedData['emisiones'];
      return emisionesJson
          .map((json) => EmisionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return null;
  }

  @override
  Future<void> cacheEmisiones(List<EmisionModel> emisiones) async {
    final jsonData = {
      'emisiones': emisiones.map((e) => e.toJson()).toList(),
    };
    await cacheManager.saveData(_cacheKey, jsonData);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(_cacheKey);
  }
}
