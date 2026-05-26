import '../../../../core/cache/cache_manager.dart';
import '../models/santo_model.dart';

/// Local data source para santos usando caché
abstract class SantosLocalDataSource {
  /// Obtiene el santo del día desde el caché
  Future<SantoModel?> getCachedSantoDelDia();

  /// Guarda el santo del día en caché
  Future<void> cacheSantoDelDia(SantoModel santo);

  /// Limpia el caché del santo del día
  Future<void> clearCache();
}

class SantosLocalDataSourceImpl implements SantosLocalDataSource {
  final CacheManager cacheManager;

  SantosLocalDataSourceImpl({required this.cacheManager});

  @override
  Future<SantoModel?> getCachedSantoDelDia() async {
    final cachedData = await cacheManager.getData(
      CacheKeys.santoDelDia,
      ttl: const Duration(hours: 12), // Caché válido por 12 horas
    );

    if (cachedData == null) {
      return null;
    }

    try {
      return SantoModel.fromJson(cachedData);
    } catch (e) {
      // Si hay error al parsear, limpiar el caché
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> cacheSantoDelDia(SantoModel santo) async {
    final jsonData = santo.toJson();
    await cacheManager.saveData(CacheKeys.santoDelDia, jsonData);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(CacheKeys.santoDelDia);
  }
}
