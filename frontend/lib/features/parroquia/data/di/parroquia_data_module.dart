import 'package:injectable/injectable.dart';
import '../datasources/parroquia_local_datasource.dart';
import '../../../../core/cache/cache_manager.dart';

@module
abstract class ParroquiaDataModule {
  @injectable
  ParroquiaLocalDataSource parroquiaLocalDataSource(CacheManager cacheManager) {
    return ParroquiaLocalDataSourceImpl(cacheManager);
  }
}
