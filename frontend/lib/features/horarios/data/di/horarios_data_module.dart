import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../datasources/horarios_local_datasource.dart';

@module
abstract class HorariosDataModule {
  @lazySingleton
  HorariosLocalDataSource horariosLocalDataSource(CacheManager cacheManager) =>
      HorariosLocalDataSourceImpl(cacheManager: cacheManager);
}
