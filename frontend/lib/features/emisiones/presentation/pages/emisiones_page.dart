import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/core.dart';
import '../providers/emisiones_provider.dart';
import '../../domain/entities/emision.dart';

/// Página de Emisiones (Radio y Transmisiones)
class EmisionesPage extends ConsumerWidget {
  const EmisionesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emisionesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: RefreshIndicator(
        onRefresh: () => ref.read(emisionesProvider.notifier).reload(),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            switch (state) {
              DataStateInitial() || DataStateLoading() => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cargando emisiones...',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              DataStateSuccess(:final data) => _buildSuccess(context, data),
              DataStateError(:final message) => SliverFillRemaining(
                  child: _buildError(context, ref, message),
                ),
            },
          ],
        ),
      ),
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    // Patrón canónico v2 — mismo header que Santos / Eventos / Lecturas.
    // Gradiente de marca Marrón (#9E2E21) → Dorado (#E3A822).
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Emisiones',
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
              FontAwesomeIcons.microphone,
              size: 80,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildSuccess(BuildContext context, List<Emision> emisiones) {
    if (emisiones.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.microphone,
                size: 64,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay emisiones disponibles',
                style: AppTheme.headingSmall.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Separar emisiones en vivo
    final enVivo = emisiones.where((e) => e.enVivo).toList();
    final grabadas = emisiones.where((e) => !e.enVivo).toList();

    return SliverList(
      delegate: SliverChildListDelegate([
        if (enVivo.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Text(
              '🔴 EN VIVO AHORA',
              style: AppTheme.headingSmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...enVivo.map((emision) => _buildEmisionCard(context, emision, true)),
          const SizedBox(height: AppTheme.spacingL),
        ],
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Text(
            'Transmisiones Anteriores',
            style: AppTheme.headingSmall.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...grabadas
            .map((emision) => _buildEmisionCard(context, emision, false)),
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _buildEmisionCard(BuildContext context, Emision emision, bool enVivo) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
        border: Border.all(
          color: enVivo
              ? Colors.red.withOpacity(0.5)
              : AppColors.parishGold.withOpacity(0.2),
          width: enVivo ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusLarge),
                topRight: Radius.circular(AppTheme.radiusLarge),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.play,
                    size: 48,
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                ),
                if (enVivo)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'EN VIVO',
                            style: AppTheme.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categoría
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    emision.categoria,
                    style: AppTheme.caption.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                // Título
                Text(
                  emision.titulo,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXS),
                // Descripción
                Text(
                  emision.descripcion,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppColors.mediumGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingS),
                // Meta info
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: 12,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      emision.duracion,
                      style: AppTheme.caption.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(width: 16),
                    FaIcon(
                      FontAwesomeIcons.eye,
                      size: 12,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${emision.vistas} vistas',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar emisiones',
              style: AppTheme.headingSmall.copyWith(
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(emisionesProvider.notifier).reload(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
