import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/cache/cache_manager.dart';

// Features imports
import 'features/lecturas/data/datasources/lecturas_local_datasource.dart';
import 'features/lecturas/data/datasources/lecturas_remote_datasource.dart';
import 'features/lecturas/data/repositories/lecturas_repository_impl.dart';
import 'features/lecturas/domain/repositories/lecturas_repository.dart';
import 'features/lecturas/domain/usecases/get_lecturas_del_dia.dart';
import 'features/lecturas/presentation/providers/lecturas_provider.dart';

import 'features/santos/data/datasources/santos_local_datasource.dart';
import 'features/santos/data/datasources/santos_remote_data_source.dart';
import 'features/santos/data/datasources/santos_remote_data_source_impl.dart';
import 'features/santos/data/repositories/santos_repository_impl.dart';
import 'features/santos/domain/repositories/santos_repository.dart';
import 'features/santos/domain/usecases/get_santo_del_dia.dart';

import 'features/eventos/data/datasources/eventos_local_datasource.dart';
import 'features/eventos/data/datasources/eventos_remote_data_source.dart';
import 'features/eventos/data/datasources/eventos_remote_data_source_impl.dart';
import 'features/eventos/data/repositories/eventos_repository_impl.dart';
import 'features/eventos/domain/repositories/eventos_repository.dart';
import 'features/eventos/domain/usecases/get_eventos_activos.dart';

import 'features/horarios/data/datasources/horarios_local_datasource.dart';
import 'features/horarios/data/datasources/horarios_remote_datasource.dart';
import 'features/horarios/data/repositories/horarios_repository_impl.dart';
import 'features/horarios/domain/repositories/horarios_repository.dart';
import 'features/horarios/domain/usecases/get_horarios_activos.dart';
import 'features/horarios/presentation/providers/horarios_provider.dart';

import 'features/emisiones/data/datasources/emisiones_local_datasource.dart';
import 'features/emisiones/data/datasources/emisiones_remote_datasource.dart';
import 'features/emisiones/data/repositories/emisiones_repository_impl.dart';
import 'features/emisiones/domain/repositories/emisiones_repository.dart';
import 'features/emisiones/domain/usecases/get_emisiones_activas.dart';
import 'features/emisiones/presentation/providers/emisiones_provider.dart';

import 'features/parroquia/data/datasources/parroquia_local_datasource.dart';
import 'features/parroquia/data/datasources/parroquia_remote_datasource.dart';
import 'features/parroquia/data/repositories/parroquia_repository_impl.dart';
import 'features/parroquia/domain/repositories/parroquia_repository.dart';
import 'features/parroquia/domain/usecases/get_parroquia_info.dart';
import 'features/parroquia/presentation/providers/parroquia_provider.dart';

import 'features/oficina/data/datasources/oficina_local_datasource.dart';
import 'features/oficina/data/datasources/oficina_remote_datasource.dart';
import 'features/oficina/data/repositories/oficina_repository_impl.dart';
import 'features/oficina/domain/repositories/oficina_repository.dart';
import 'features/oficina/domain/usecases/get_oficina_info.dart';
import 'features/oficina/presentation/providers/oficina_provider.dart';

// Este archivo será generado por injectable_generator
// import 'injection.config.dart';

final getIt = GetIt.instance;

// Configuración temporal hasta generar el archivo config
Future<void> configureDependencies() async {
  // ========== Core Dependencies ==========
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(getIt<Connectivity>()));

  // Registrar SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // Registrar CacheManager
  getIt.registerLazySingleton<CacheManager>(
      () => CacheManager(getIt<SharedPreferences>()));

  // ========== Lecturas Feature ==========
  getIt.registerLazySingleton<LecturasRemoteDataSource>(
      () => LecturasRemoteDataSourceImpl(dioClient: getIt<DioClient>()));
  getIt.registerLazySingleton<LecturasLocalDataSource>(
      () => LecturasLocalDataSourceImpl(cacheManager: getIt<CacheManager>()));
  getIt.registerLazySingleton<LecturasRepository>(() => LecturasRepositoryImpl(
        remoteDataSource: getIt<LecturasRemoteDataSource>(),
        localDataSource: getIt<LecturasLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetLecturasDelDia>(
      () => GetLecturasDelDia(getIt<LecturasRepository>()));
  getIt.registerFactory<LecturasNotifier>(
      () => LecturasNotifier(getIt<GetLecturasDelDia>()));

  // ========== Santos Feature ==========
  getIt.registerLazySingleton<SantosRemoteDataSource>(
      () => SantosRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<SantosLocalDataSource>(
      () => SantosLocalDataSourceImpl(cacheManager: getIt<CacheManager>()));
  getIt.registerLazySingleton<SantosRepository>(() => SantosRepositoryImpl(
        remoteDataSource: getIt<SantosRemoteDataSource>(),
        localDataSource: getIt<SantosLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetSantoDelDia>(
      () => GetSantoDelDia(getIt<SantosRepository>()));

  // ========== Eventos Feature ==========
  getIt.registerLazySingleton<EventosRemoteDataSource>(
      () => EventosRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<EventosLocalDataSource>(
      () => EventosLocalDataSourceImpl(cacheManager: getIt<CacheManager>()));
  getIt.registerLazySingleton<EventosRepository>(() => EventosRepositoryImpl(
        remoteDataSource: getIt<EventosRemoteDataSource>(),
        localDataSource: getIt<EventosLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetEventosActivos>(
      () => GetEventosActivos(getIt<EventosRepository>()));

  // ========== Horarios Feature ==========
  getIt.registerLazySingleton<HorariosRemoteDataSource>(
      () => HorariosRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<HorariosLocalDataSource>(
      () => HorariosLocalDataSourceImpl(cacheManager: getIt<CacheManager>()));
  getIt.registerLazySingleton<HorariosRepository>(() => HorariosRepositoryImpl(
        remoteDataSource: getIt<HorariosRemoteDataSource>(),
        localDataSource: getIt<HorariosLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetHorariosActivos>(
      () => GetHorariosActivos(getIt<HorariosRepository>()));
  getIt.registerFactory<HorariosNotifier>(
      () => HorariosNotifier(getIt<GetHorariosActivos>()));

  // ========== Emisiones Feature ==========
  getIt.registerLazySingleton<EmisionesRemoteDataSource>(
      () => EmisionesRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<EmisionesLocalDataSource>(
      () => EmisionesLocalDataSourceImpl(getIt<CacheManager>()));
  getIt.registerLazySingleton<EmisionesRepository>(() => EmisionesRepositoryImpl(
        remoteDataSource: getIt<EmisionesRemoteDataSource>(),
        localDataSource: getIt<EmisionesLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetEmisionesActivas>(
      () => GetEmisionesActivas(getIt<EmisionesRepository>()));
  getIt.registerFactory<EmisionesNotifier>(
      () => EmisionesNotifier(getIt<GetEmisionesActivas>()));

  // ========== Parroquia Feature ==========
  getIt.registerLazySingleton<ParroquiaRemoteDataSource>(
      () => ParroquiaRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<ParroquiaLocalDataSource>(
      () => ParroquiaLocalDataSourceImpl(getIt<CacheManager>()));
  getIt.registerLazySingleton<ParroquiaRepository>(() => ParroquiaRepositoryImpl(
        remoteDataSource: getIt<ParroquiaRemoteDataSource>(),
        localDataSource: getIt<ParroquiaLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetParroquiaInfo>(
      () => GetParroquiaInfo(getIt<ParroquiaRepository>()));
  getIt.registerFactory<ParroquiaNotifier>(
      () => ParroquiaNotifier(getIt<GetParroquiaInfo>()));

  // ========== Oficina Feature ==========
  getIt.registerLazySingleton<OficinaRemoteDataSource>(
      () => OficinaRemoteDataSourceImpl(getIt<DioClient>()));
  getIt.registerLazySingleton<OficinaLocalDataSource>(
      () => OficinaLocalDataSourceImpl(getIt<CacheManager>()));
  getIt.registerLazySingleton<OficinaRepository>(() => OficinaRepositoryImpl(
        remoteDataSource: getIt<OficinaRemoteDataSource>(),
        localDataSource: getIt<OficinaLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ));
  getIt.registerLazySingleton<GetOficinaInfo>(
      () => GetOficinaInfo(getIt<OficinaRepository>()));
  getIt.registerFactory<OficinaNotifier>(
      () => OficinaNotifier(getIt<GetOficinaInfo>()));
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  DioClient get dioClient => DioClient();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl(getIt<Connectivity>());

  @lazySingleton
  CacheManager get cacheManager => CacheManager(getIt<SharedPreferences>());
}
