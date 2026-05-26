import '../../../../core/cache/cache_manager.dart';
import '../models/evento_model.dart';

/// Local data source para eventos usando caché
abstract class EventosLocalDataSource {
  /// Obtiene los eventos activos desde el caché
  Future<List<EventoModel>?> getCachedEventosActivos();

  /// Guarda los eventos activos en caché
  Future<void> cacheEventosActivos(List<EventoModel> eventos);

  /// Limpia el caché de eventos
  Future<void> clearCache();
}

class EventosLocalDataSourceImpl implements EventosLocalDataSource {
  final CacheManager cacheManager;

  EventosLocalDataSourceImpl({required this.cacheManager});

  @override
  Future<List<EventoModel>?> getCachedEventosActivos() async {
    final cachedData = await cacheManager.getData(
      CacheKeys.eventosActivos,
      ttl: const Duration(hours: 8), // Caché válido por 8 horas
    );

    if (cachedData == null) {
      return null;
    }

    try {
      final List<dynamic> eventosJson = cachedData['eventos'] as List<dynamic>;
      return eventosJson
          .map((json) => EventoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Si hay error al parsear, limpiar el caché
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> cacheEventosActivos(List<EventoModel> eventos) async {
    final jsonData = {
      'eventos': eventos.map((e) => e.toJson()).toList(),
    };
    await cacheManager.saveData(CacheKeys.eventosActivos, jsonData);
  }

  @override
  Future<void> clearCache() async {
    await cacheManager.clearData(CacheKeys.eventosActivos);
  }
}
