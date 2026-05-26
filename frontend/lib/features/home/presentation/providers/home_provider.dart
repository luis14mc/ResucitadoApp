import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/home_section.dart';
import '../../../santos/presentation/providers/santo_del_dia_provider.dart';
import '../../../eventos/presentation/providers/eventos_provider.dart';
import '../../../lecturas/presentation/providers/lecturas_provider.dart';
import '../../../horarios/presentation/providers/horarios_provider.dart';
import '../../../../core/presentation/state/data_state.dart';

/// Provider que gestiona el estado del Home Dashboard
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

class HomeState {
  final List<HomeSection> sections;
  final SantoSummary? santoSummary;
  final EventosSummary? eventosSummary;
  final LecturasSummary? lecturasSummary;
  final HorariosSummary? horariosSummary;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.sections = const [],
    this.santoSummary,
    this.eventosSummary,
    this.lecturasSummary,
    this.horariosSummary,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<HomeSection>? sections,
    SantoSummary? santoSummary,
    EventosSummary? eventosSummary,
    LecturasSummary? lecturasSummary,
    HorariosSummary? horariosSummary,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      sections: sections ?? this.sections,
      santoSummary: santoSummary ?? this.santoSummary,
      eventosSummary: eventosSummary ?? this.eventosSummary,
      lecturasSummary: lecturasSummary ?? this.lecturasSummary,
      horariosSummary: horariosSummary ?? this.horariosSummary,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(const HomeState()) {
    _initialize();
  }

  void _initialize() {
    // Escuchar cambios en los providers de features
    ref.listen(santoDelDiaProvider, (previous, next) {
      _updateSantoSummary(next);
    });

    ref.listen(eventosProvider, (previous, next) {
      _updateEventosSummary(next);
    });

    ref.listen(lecturasProvider, (previous, next) {
      _updateLecturasSummary(next);
    });

    ref.listen(horariosProvider, (previous, next) {
      _updateHorariosSummary(next);
    });

    // Cargar datos iniciales
    loadAll();
  }

  /// Carga todos los datos de las features
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);

    try {
      // Cargar datos de cada feature
      await Future.wait<void>([
        ref.read(santoDelDiaProvider.notifier).loadSantoDelDia(),
        ref.read(eventosProvider.notifier).loadEventos(),
        ref.read(lecturasProvider.notifier).loadLecturas(),
        ref.read(horariosProvider.notifier).loadHorarios(),
      ]);

      _buildSections();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar datos: ${e.toString()}',
      );
    }
  }

  void _updateSantoSummary(DataState<dynamic> dataState) {
    if (dataState is DataStateSuccess) {
      final santo = dataState.data;
      final summary = SantoSummary(
        nombre: santo.nombre,
        festividad: santo.festividad ?? 'Santo del día',
        fecha: santo.fecha,
      );
      state = state.copyWith(santoSummary: summary);
      _buildSections();
    }
  }

  void _updateEventosSummary(DataState<dynamic> dataState) {
    if (dataState is DataStateSuccess) {
      final eventos = dataState.data as List<dynamic>;
      final now = DateTime.now();
      final proximosSemanales = eventos.where((e) {
        final diff = e.fecha.difference(now).inDays;
        return diff >= 0 && diff <= 7;
      }).length;

      final proximoEvento = eventos.isNotEmpty ? eventos.first.titulo : null;

      final summary = EventosSummary(
        totalActivos: eventos.length,
        proximosSemanales: proximosSemanales,
        proximoEvento: proximoEvento,
      );
      state = state.copyWith(eventosSummary: summary);
      _buildSections();
    }
  }

  void _updateLecturasSummary(DataState<dynamic> dataState) {
    if (dataState is DataStateSuccess) {
      final lecturasDelDia = dataState.data;
      final evangelio = lecturasDelDia.evangelio?.titulo ?? 'Evangelio del día';
      final summary = LecturasSummary(
        evangelio: evangelio,
        colorLiturgico: lecturasDelDia.colorLiturgico,
        totalLecturas: _countLecturas(lecturasDelDia),
      );
      state = state.copyWith(lecturasSummary: summary);
      _buildSections();
    }
  }

  int _countLecturas(dynamic lecturasDelDia) {
    int count = 0;
    if (lecturasDelDia.primeraLectura != null) count++;
    if (lecturasDelDia.segundaLectura != null) count++;
    if (lecturasDelDia.salmo != null) count++;
    if (lecturasDelDia.evangelio != null) count++;
    return count;
  }

  void _updateHorariosSummary(DataState<dynamic> dataState) {
    if (dataState is DataStateSuccess) {
      final horarios = dataState.data as List<dynamic>;
      final now = DateTime.now();
      final diaHoy = _getDiaSemanaFromDateTime(now);

      final horariosHoy = horarios
          .where((h) =>
              h.dia.name.toLowerCase() == diaHoy.toLowerCase() && h.activo)
          .toList();

      String? proximaMisa;
      if (horariosHoy.isNotEmpty) {
        proximaMisa = horariosHoy.first.hora;
      }

      final summary = HorariosSummary(
        totalHorarios: horarios.where((h) => h.activo).length,
        proximaMisa: proximaMisa,
        diaSemana: _getDiaSemanaDisplay(diaHoy),
      );
      state = state.copyWith(horariosSummary: summary);
      _buildSections();
    }
  }

  String _getDiaSemanaFromDateTime(DateTime date) {
    const dias = [
      'lunes',
      'martes',
      'miercoles',
      'jueves',
      'viernes',
      'sabado',
      'domingo'
    ];
    return dias[date.weekday - 1];
  }

  String _getDiaSemanaDisplay(String dia) {
    const displayNames = {
      'lunes': 'Lunes',
      'martes': 'Martes',
      'miercoles': 'Miércoles',
      'jueves': 'Jueves',
      'viernes': 'Viernes',
      'sabado': 'Sábado',
      'domingo': 'Domingo',
    };
    return displayNames[dia] ?? dia;
  }

  void _buildSections() {
    final sections = <HomeSection>[
      HomeSection(
        id: 'lecturas',
        title: 'Lecturas del Día',
        subtitle: state.lecturasSummary != null
            ? '${state.lecturasSummary!.totalLecturas} lecturas'
            : 'Palabra de Dios',
        icon: FontAwesomeIcons.bookBible,
        route: '/lecturasDelDia',
        itemCount: state.lecturasSummary?.totalLecturas,
      ),
      HomeSection(
        id: 'eventos',
        title: 'Eventos',
        subtitle: state.eventosSummary != null
            ? '${state.eventosSummary!.proximosSemanales} esta semana'
            : 'Vida parroquial',
        icon: FontAwesomeIcons.calendarDays,
        route: '/eventos',
        itemCount: state.eventosSummary?.totalActivos,
      ),
      HomeSection(
        id: 'emisiones',
        title: 'Emisiones',
        subtitle: 'Radio y transmisiones',
        icon: FontAwesomeIcons.microphone,
        route: '/emisiones',
      ),
      HomeSection(
        id: 'parroquia',
        title: 'Nuestra Parroquia',
        subtitle: 'Historia y misión',
        icon: FontAwesomeIcons.church,
        route: '/nuestraParroquia',
      ),
      HomeSection(
        id: 'oficina',
        title: 'Oficina Parroquial',
        subtitle: 'Contacto y servicios',
        icon: FontAwesomeIcons.handsPraying,
        route: '/oficinaParroquial',
      ),
      HomeSection(
        id: 'horarios',
        title: 'Horarios de Misa',
        subtitle: state.horariosSummary?.proximaMisa != null
            ? 'Próxima: ${state.horariosSummary!.proximaMisa}'
            : 'Celebraciones',
        icon: FontAwesomeIcons.cross,
        route: '/horarios',
        itemCount: state.horariosSummary?.totalHorarios,
      ),
    ];

    state = state.copyWith(sections: sections);
  }

  /// Refresca todos los datos
  Future<void> refresh() async {
    await loadAll();
  }
}
