import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../datasources/eventos_local_datasource.dart';

@module
abstract class EventosDataModule {
  @lazySingleton
  EventosLocalDataSource eventosLocalDataSource(CacheManager cacheManager) =>
      EventosLocalDataSourceImpl(cacheManager: cacheManager);
}
