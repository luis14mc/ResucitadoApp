import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/lecturas/presentation/pages/lecturas_dia_page.dart';
import '../../../features/santos/presentation/pages/santo_del_dia_page.dart';
import '../../../features/eventos/presentation/pages/eventos_page.dart';
import '../../../features/horarios/presentation/pages/horarios_misa_page.dart';
import '../../../features/emisiones/presentation/pages/emisiones_page.dart';
import '../../../features/parroquia/presentation/pages/nuestra_parroquia_page.dart';
import '../../../features/oficina/presentation/pages/oficina_parroquial_page.dart';

/// Configuración de rutas de la aplicación usando GoRouter
///
/// Proporciona navegación type-safe y deep linking
class AppRouter {
  static const String home = '/';
  static const String lecturasDelDia = '/lecturasDelDia';
  static const String santoDelDia = '/santoDelDia';
  static const String eventos = '/eventos';
  static const String emisiones = '/emisiones';
  static const String nuestraParroquia = '/nuestraParroquia';
  static const String oficinaParroquial = '/oficinaParroquial';
  static const String horarios = '/horarios';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: lecturasDelDia,
        name: 'lecturasDelDia',
        builder: (context, state) => const LecturasDiaPage(),
      ),
      GoRoute(
        path: santoDelDia,
        name: 'santoDelDia',
        builder: (context, state) => const SantoDelDiaPage(),
      ),
      GoRoute(
        path: eventos,
        name: 'eventos',
        builder: (context, state) => const EventosPage(),
      ),
      GoRoute(
        path: emisiones,
        name: 'emisiones',
        builder: (context, state) => const EmisionesPage(),
      ),
      GoRoute(
        path: nuestraParroquia,
        name: 'nuestraParroquia',
        builder: (context, state) => const NuestraParroquiaPage(),
      ),
      GoRoute(
        path: oficinaParroquial,
        name: 'oficinaParroquial',
        builder: (context, state) => const OficinaParroquialPage(),
      ),
      GoRoute(
        path: horarios,
        name: 'horarios',
        builder: (context, state) => const HorariosMisaPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Extension methods para navegación más fácil
extension GoRouterExtension on BuildContext {
  /// Navega a la página de inicio
  void goHome() => go(AppRouter.home);

  /// Navega a lecturas del día
  void goLecturasDelDia() => go(AppRouter.lecturasDelDia);

  /// Navega a santo del día
  void goSantoDelDia() => go(AppRouter.santoDelDia);

  /// Navega a eventos
  void goEventos() => go(AppRouter.eventos);

  /// Navega a emisiones
  void goEmisiones() => go(AppRouter.emisiones);

  /// Navega a nuestra parroquia
  void goNuestraParroquia() => go(AppRouter.nuestraParroquia);

  /// Navega a oficina parroquial
  void goOficinaParroquial() => go(AppRouter.oficinaParroquial);

  /// Navega a horarios
  void goHorarios() => go(AppRouter.horarios);
}
