import 'package:injectable/injectable.dart';
import '../datasources/emisiones_local_datasource.dart';
import '../../../../core/cache/cache_manager.dart';

@module
abstract class EmisionesDataModule {
  @injectable
  EmisionesLocalDataSource emisionesLocalDataSource(CacheManager cacheManager) {
    return EmisionesLocalDataSourceImpl(cacheManager);
  }
}
