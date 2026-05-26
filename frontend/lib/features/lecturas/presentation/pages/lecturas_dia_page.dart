import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../core/presentation/state/data_state.dart';
import '../../domain/entities/lectura.dart';
import '../providers/lecturas_provider.dart';

/// Página de Lecturas del Día con Clean Architecture
class LecturasDiaPage extends ConsumerWidget {
  const LecturasDiaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lecturasState = ref.watch(lecturasProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: _buildBody(context, ref, lecturasState),
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    DataState<Lectura> state,
  ) {
    return switch (state) {
      DataStateInitial() => _buildInitialState(),
      DataStateLoading() => _buildLoadingState(),
      DataStateSuccess(:final data) => _buildSuccessState(context, data),
      DataStateError(:final message) => _buildErrorState(context, message, ref),
    };
  }

  Widget _buildInitialState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando lecturas del día...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, Lectura lectura) {
    final formattedDate = DateFormat('dd/MM/yyyy', 'es').format(lectura.fecha);

    return CustomScrollView(
      slivers: [
        _buildAppBar(context, formattedDate),
        SliverPadding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Tiempo litúrgico
              _buildInfoCard(
                lectura.tiempoLiturgico,
                Icons.calendar_today,
                _getColorLiturgico(lectura.colorLiturgico),
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Primera Lectura
              _buildReadingCard(
                'Primera Lectura',
                lectura.primeraLectura.titulo,
                lectura.primeraLectura.referencia,
                lectura.primeraLectura.texto,
                const Color(0xFF4A90E2),
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Salmo Responsorial
              _buildSalmoCard(lectura.salmo),
              const SizedBox(height: AppTheme.spacingL),

              // Segunda Lectura (opcional)
              if (lectura.segundaLectura != null) ...[
                _buildReadingCard(
                  'Segunda Lectura',
                  lectura.segundaLectura!.titulo,
                  lectura.segundaLectura!.referencia,
                  lectura.segundaLectura!.texto,
                  const Color(0xFF9B59B6),
                ),
                const SizedBox(height: AppTheme.spacingL),
              ],

              // Evangelio
              _buildReadingCard(
                'Evangelio',
                lectura.evangelio.titulo,
                lectura.evangelio.referencia,
                lectura.evangelio.texto,
                AppColors.primaryColor,
              ),
              const SizedBox(height: AppTheme.spacingL),

              // Reflexión (opcional)
              if (lectura.reflexion != null) ...[
                _buildReadingCard(
                  'Reflexión',
                  lectura.reflexion!.titulo,
                  lectura.reflexion!.fuente,
                  lectura.reflexion!.texto,
                  const Color(0xFFE74C3C),
                ),
                const SizedBox(height: AppTheme.spacingXXL),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: AppTheme.spacingL),
            const Text(
              'Error al cargar las lecturas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(lecturasProvider.notifier).reload();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingXL,
                  vertical: AppTheme.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String formattedDate) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppTheme.radiusXLarge),
              bottomRight: Radius.circular(AppTheme.radiusXLarge),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lecturas del Día',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    ),
                    child: Text(
                      'Fecha: $formattedDate',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(
    String titulo,
    String subtitulo,
    String referencia,
    String texto,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  referencia,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalmoCard(Salmo salmo) {
    const color = Color(0xFF27AE60);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    const Text(
                      'Salmo Responsorial',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  salmo.titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  salmo.referencia,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Respuesta
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingM),
            margin: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Respuesta:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  salmo.respuesta,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          // Texto del salmo
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingM,
              0,
              AppTheme.spacingM,
              AppTheme.spacingM,
            ),
            child: Text(
              salmo.texto,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorLiturgico(String color) {
    return switch (color.toLowerCase()) {
      'verde' => const Color(0xFF27AE60),
      'morado' || 'violeta' => const Color(0xFF9B59B6),
      'blanco' => const Color(0xFFECF0F1),
      'rojo' => const Color(0xFFE74C3C),
      'rosa' => const Color(0xFFE91E63),
      _ => AppColors.primaryColor,
    };
  }
}
