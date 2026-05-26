import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../datasources/santos_local_datasource.dart';

@module
abstract class SantosDataModule {
  @lazySingleton
  SantosLocalDataSource santosLocalDataSource(CacheManager cacheManager) =>
      SantosLocalDataSourceImpl(cacheManager: cacheManager);
}
