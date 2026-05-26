import '../../../../core/cache/cache_manager.dart';
import '../models/horario_misa_model.dart';

/// Local data source para horarios usando caché
abstract class HorariosLocalDataSource {
  /// Obtiene los horarios desde el caché
  Future<List<HorarioMisaModel>?> getCachedHorarios();

  /// Guarda los horarios en caché
  Future<void> cacheHorarios(List<HorarioMisaModel> horarios);

  /// Limpia el caché de horarios
  Future<void> clearCache();
}

class HorariosLocalDataSourceImpl implements HorariosLocalDataSource {
  final CacheManager cacheManager;
  static const String _cacheKey = 'horarios_misa';

  HorariosLocalDataSourceImpl({required this.cacheManager});

  @override
  Future<List<HorarioMisaModel>?> getCachedHorarios() async {
    final cachedData = await cacheManager.getData(
      _cacheKey,
      ttl: const Duration(hours: 72), // Caché válido por 72 horas (3 días)
    );

    if (cachedData == null) {
      return null;
    }

    try {
      final List<dynamic> horariosJson =
          cachedData['horarios'] as List<dynamic>;
      return horariosJson
          .map(
              (json) => HorarioMisaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Si hay error al parsear, limpiar el caché
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> cacheHorarios(List<HorarioMisaModel> horarios) async {
    final jsonData = {
      'horarios': horarios.map((h) => h.toJson()).toList(),
    };
    await cacheManager.saveData(_cacheKey, jsonData);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(_cacheKey);
  }
}
