import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/widgets/footer_widget.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/evento.dart';
import '../providers/eventos_provider.dart';

/// Página de Eventos usando Clean Architecture
///
/// Muestra todos los eventos activos de la parroquia
/// con filtros por categoría
class EventosPage extends ConsumerStatefulWidget {
  const EventosPage({super.key});

  @override
  ConsumerState<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends ConsumerState<EventosPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  EventoCategoria? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventosState = ref.watch(eventosProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildBody(eventosState),
          ),
        ],
      ),
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildBody(DataState<List<Evento>> state) {
    return switch (state) {
      DataStateInitial() => _buildInitialState(),
      DataStateLoading() => _buildLoadingState(),
      DataStateSuccess(data: final eventos) => _buildSuccessState(eventos),
      DataStateError(message: final error) => _buildErrorState(error),
    };
  }

  Widget _buildInitialState() {
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Cargando eventos...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            size: 60,
            color: AppColors.error,
          ),
          const SizedBox(height: 20),
          Text(
            'Error al cargar eventos',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            error,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(eventosProvider.notifier).reload();
            },
            icon: const Icon(FontAwesomeIcons.arrowsRotate, size: 16),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(List<Evento> eventos) {
    // Filtrar por categoría si está seleccionada
    final eventosFiltrados = _categoriaSeleccionada == null
        ? eventos
        : eventos.where((e) => e.categoria == _categoriaSeleccionada).toList();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildCategoriesFilter(),
          if (eventosFiltrados.isEmpty)
            _buildEmptyState()
          else
            _buildEventsList(eventosFiltrados),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Eventos Parroquiales',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Center(
            child: Icon(
              FontAwesomeIcons.calendarDays,
              size: 70,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildCategoriesFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(null, 'Todos', FontAwesomeIcons.list),
          _buildCategoryChip(
              EventoCategoria.liturgia, 'Liturgia', FontAwesomeIcons.church),
          _buildCategoryChip(EventoCategoria.comunidad, 'Comunidad',
              FontAwesomeIcons.peopleGroup),
          _buildCategoryChip(
              EventoCategoria.juventud, 'Juventud', FontAwesomeIcons.users),
          _buildCategoryChip(EventoCategoria.formacion, 'Formación',
              FontAwesomeIcons.bookBible),
          _buildCategoryChip(EventoCategoria.mision, 'Misión',
              FontAwesomeIcons.handHoldingHeart),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      EventoCategoria? categoria, String label, IconData icon) {
    final isSelected = _categoriaSeleccionada == categoria;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            _categoriaSeleccionada = selected ? categoria : null;
            _animationController.reset();
            _animationController.forward();
          });
        },
        selectedColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryColor
              : AppColors.textSecondary.withOpacity(0.3),
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.calendarXmark,
            size: 60,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay eventos disponibles',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _categoriaSeleccionada == null
                ? 'Aún no se han programado eventos'
                : 'No hay eventos en esta categoría',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Evento> eventos) {
    // Agrupar eventos por mes
    final eventosPorMes = <String, List<Evento>>{};
    for (final evento in eventos) {
      final mesKey = DateFormat('MMMM yyyy', 'es_ES').format(evento.fecha);
      eventosPorMes.putIfAbsent(mesKey, () => []).add(evento);
    }

    // Ordenar meses
    final mesesOrdenados = eventosPorMes.keys.toList()
      ..sort((a, b) {
        final fechaA = DateFormat('MMMM yyyy', 'es_ES').parse(a);
        final fechaB = DateFormat('MMMM yyyy', 'es_ES').parse(b);
        return fechaA.compareTo(fechaB);
      });

    return Column(
      children: mesesOrdenados.map((mes) {
        final eventosDelMes = eventosPorMes[mes]!;
        return _buildMonthSection(mes, eventosDelMes);
      }).toList(),
    );
  }

  Widget _buildMonthSection(String mes, List<Evento> eventos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            mes.toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...eventos.map((evento) => _buildEventoCard(evento)),
      ],
    );
  }

  Widget _buildEventoCard(Evento evento) {
    final categoriaColor = _getCategoriaColor(evento.categoria);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _mostrarDetalleEvento(evento),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fecha destacada
                _buildFechaBox(evento.fecha, categoriaColor),
                const SizedBox(width: 16),
                // Información del evento
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoriaColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getCategoriaLabel(evento.categoria),
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: categoriaColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Título
                      Text(
                        evento.titulo,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Hora y lugar
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            evento.hora,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              evento.lugar,
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Indicadores adicionales
                      if (evento.requiereInscripcion || evento.esRecurrente)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              if (evento.requiereInscripcion)
                                _buildBadge(
                                  'Inscripción requerida',
                                  FontAwesomeIcons.clipboardCheck,
                                  AppColors.info,
                                ),
                              if (evento.esRecurrente)
                                _buildBadge(
                                  'Evento recurrente',
                                  FontAwesomeIcons.repeat,
                                  AppColors.parishGold,
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Ícono de categoría
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categoriaColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FaIcon(
                    _getCategoriaIcon(evento.categoria),
                    size: 20,
                    color: categoriaColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFechaBox(DateTime fecha, Color color) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('d', 'es_ES').format(fecha),
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('MMM', 'es_ES').format(fecha).toUpperCase(),
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDetalleEvento(Evento evento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetalleEvento(evento),
    );
  }

  Widget _buildDetalleEvento(Evento evento) {
    final categoriaColor = _getCategoriaColor(evento.categoria);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: categoriaColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              _getCategoriaIcon(evento.categoria),
                              size: 14,
                              color: categoriaColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getCategoriaLabel(evento.categoria),
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: categoriaColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Título
                      Text(
                        evento.titulo,
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Información principal
                      _buildInfoRow(
                        FontAwesomeIcons.calendar,
                        'Fecha',
                        DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'es_ES')
                            .format(evento.fecha),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        FontAwesomeIcons.clock,
                        'Hora',
                        evento.hora,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        FontAwesomeIcons.locationDot,
                        'Lugar',
                        evento.lugar,
                      ),
                      const SizedBox(height: 24),
                      // Descripción
                      Text(
                        'Descripción',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        evento.descripcion,
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      // Información adicional
                      if (evento.requiereInscripcion) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.info.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.clipboardCheck,
                                    size: 18,
                                    color: AppColors.info,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Se requiere inscripción',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.info,
                                    ),
                                  ),
                                ],
                              ),
                              if (evento.maximoParticipantes != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Plazas disponibles: ${evento.maximoParticipantes! - evento.participantesActuales} de ${evento.maximoParticipantes}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      // Contacto
                      if (evento.contactoResponsable != null ||
                          evento.telefono != null ||
                          evento.email != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Contacto',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (evento.contactoResponsable != null)
                          _buildInfoRow(
                            FontAwesomeIcons.user,
                            'Responsable',
                            evento.contactoResponsable!,
                          ),
                        if (evento.telefono != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            FontAwesomeIcons.phone,
                            'Teléfono',
                            evento.telefono!,
                          ),
                        ],
                        if (evento.email != null) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            FontAwesomeIcons.envelope,
                            'Email',
                            evento.email!,
                          ),
                        ],
                      ],
                      const SizedBox(height: 32),
                      // Botón de acción
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implementar inscripción o más información
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: categoriaColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            evento.requiereInscripcion
                                ? 'Inscribirse'
                                : 'Más información',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            color: AppColors.primaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCategoriaColor(EventoCategoria categoria) {
    return switch (categoria) {
      EventoCategoria.liturgia => const Color(0xFF8C2727),
      EventoCategoria.comunidad => const Color(0xFF2C5F7C),
      EventoCategoria.juventud => const Color(0xFF5C8C27),
      EventoCategoria.formacion => const Color(0xFFD99A25),
      EventoCategoria.mision => const Color(0xFF8C2757),
    };
  }

  IconData _getCategoriaIcon(EventoCategoria categoria) {
    return switch (categoria) {
      EventoCategoria.liturgia => FontAwesomeIcons.church,
      EventoCategoria.comunidad => FontAwesomeIcons.peopleGroup,
      EventoCategoria.juventud => FontAwesomeIcons.users,
      EventoCategoria.formacion => FontAwesomeIcons.bookBible,
      EventoCategoria.mision => FontAwesomeIcons.handHoldingHeart,
    };
  }

  String _getCategoriaLabel(EventoCategoria categoria) {
    return switch (categoria) {
      EventoCategoria.liturgia => 'Liturgia',
      EventoCategoria.comunidad => 'Comunidad',
      EventoCategoria.juventud => 'Juventud',
      EventoCategoria.formacion => 'Formación',
      EventoCategoria.mision => 'Misión',
    };
  }
}
