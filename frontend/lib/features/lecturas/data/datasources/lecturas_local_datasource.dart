import '../../../../core/cache/cache_manager.dart';
import '../models/lectura_model.dart';

/// Local data source para lecturas usando caché
abstract class LecturasLocalDataSource {
  /// Obtiene las lecturas del día desde el caché
  Future<LecturaModel?> getCachedLecturasDelDia();

  /// Guarda las lecturas del día en caché
  Future<void> cacheLecturasDelDia(LecturaModel lecturas);

  /// Limpia el caché de lecturas
  Future<void> clearCache();
}

class LecturasLocalDataSourceImpl implements LecturasLocalDataSource {
  final CacheManager cacheManager;

  LecturasLocalDataSourceImpl({required this.cacheManager});

  @override
  Future<LecturaModel?> getCachedLecturasDelDia() async {
    final cachedData = await cacheManager.getData(
      CacheKeys.lecturasDelDia,
      ttl: const Duration(hours: 24), // Caché válido por 24 horas
    );

    if (cachedData == null) {
      return null;
    }

    try {
      return LecturaModel.fromJson(cachedData);
    } catch (e) {
      // Si hay error al parsear, limpiar el caché
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> cacheLecturasDelDia(LecturaModel lecturas) async {
    final jsonData = lecturas.toJson();
    await cacheManager.saveData(CacheKeys.lecturasDelDia, jsonData);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(CacheKeys.lecturasDelDia);
  }
}
