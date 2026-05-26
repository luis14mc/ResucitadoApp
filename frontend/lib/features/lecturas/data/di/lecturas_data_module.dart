import 'package:injectable/injectable.dart';
import '../../../../core/cache/cache_manager.dart';
import '../datasources/lecturas_local_datasource.dart';

@module
abstract class LecturasDataModule {
  @lazySingleton
  LecturasLocalDataSource lecturasLocalDataSource(CacheManager cacheManager) =>
      LecturasLocalDataSourceImpl(cacheManager: cacheManager);
}
