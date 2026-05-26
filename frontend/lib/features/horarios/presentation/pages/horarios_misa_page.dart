import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/core.dart';
import '../../domain/entities/horario_misa.dart';
import '../providers/horarios_provider.dart';

class HorariosMisaPage extends ConsumerWidget {
  const HorariosMisaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(horariosProvider);

    return Scaffold(
      // v2: alineado con el resto de pantallas (lecturas/eventos/santos).
      backgroundColor: AppColors.backgroundPrimary,
      body: switch (state) {
        DataStateInitial() => const SizedBox(),
        DataStateLoading() => _buildLoading(),
        DataStateSuccess(:final data) => _buildSuccess(context, data, ref),
        DataStateError(:final message) => _buildError(context, message, ref),
      },
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, String message, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Error al cargar los horarios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(horariosProvider.notifier).reload(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(
      BuildContext context, List<HorarioMisa> horarios, WidgetRef ref) {
    // Agrupar horarios por tipo
    final horariosPorTipo = <TipoMisa, List<HorarioMisa>>{};
    for (final horario in horarios.where((h) => h.activo)) {
      horariosPorTipo.putIfAbsent(horario.tipo, () => []).add(horario);
    }

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, ref),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(context),
                const SizedBox(height: 24),
                ...horariosPorTipo.entries.map(
                  (entry) => _buildTipoSection(
                    context,
                    entry.key,
                    entry.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    // Patrón canónico v2 — mismo header que Santos / Eventos / Lecturas.
    // Gradiente de marca Marrón (#9E2E21) → Dorado (#E3A822).
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Horarios de Misa',
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
              FontAwesomeIcons.church,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => ref.read(horariosProvider.notifier).reload(),
          tooltip: 'Actualizar',
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Los horarios pueden variar en días festivos y celebraciones especiales.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoSection(
    BuildContext context,
    TipoMisa tipo,
    List<HorarioMisa> horarios,
  ) {
    // Ordenar horarios por día
    final horariosOrdenados = List<HorarioMisa>.from(horarios)
      ..sort((a, b) {
        if (a.dia == null && b.dia == null) return 0;
        if (a.dia == null) return 1;
        if (b.dia == null) return -1;
        return a.dia!.index.compareTo(b.dia!.index);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(
                _getIconForTipo(tipo),
                color: _getColorForTipo(tipo),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                tipo.displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getColorForTipo(tipo),
                ),
              ),
            ],
          ),
        ),
        ...horariosOrdenados.map(
          (horario) => _buildHorarioCard(context, horario, tipo),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHorarioCard(
    BuildContext context,
    HorarioMisa horario,
    TipoMisa tipo,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getColorForTipo(tipo).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getColorForTipo(tipo).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: _getColorForTipo(tipo),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (horario.dia != null)
                        Text(
                          horario.dia!.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getColorForTipo(tipo),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        horario.hora,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.location_on,
              'Lugar',
              horario.lugar,
              context,
            ),
            if (horario.sacerdote != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.person,
                'Sacerdote',
                horario.sacerdote!,
                context,
              ),
            ],
            if (horario.descripcion != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.description,
                'Descripción',
                horario.descripcion!,
                context,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getIconForTipo(TipoMisa tipo) {
    switch (tipo) {
      case TipoMisa.diaria:
        return Icons.calendar_today;
      case TipoMisa.dominical:
        return Icons.church;
      case TipoMisa.festivo:
        return Icons.celebration;
      case TipoMisa.especial:
        return Icons.star;
    }
  }

  Color _getColorForTipo(TipoMisa tipo) {
    switch (tipo) {
      case TipoMisa.diaria:
        return Colors.blue;
      case TipoMisa.dominical:
        return Colors.purple;
      case TipoMisa.festivo:
        return Colors.orange;
      case TipoMisa.especial:
        return Colors.red;
    }
  }
}
