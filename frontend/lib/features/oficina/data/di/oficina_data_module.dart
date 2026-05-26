import 'package:injectable/injectable.dart';
import '../datasources/oficina_local_datasource.dart';
import '../../../../core/cache/cache_manager.dart';

@module
abstract class OficinaDataModule {
  @injectable
  OficinaLocalDataSource oficinaLocalDataSource(CacheManager cacheManager) {
    return OficinaLocalDataSourceImpl(cacheManager);
  }
}
