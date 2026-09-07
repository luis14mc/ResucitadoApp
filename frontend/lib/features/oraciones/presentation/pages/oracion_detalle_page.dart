import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../providers/oracion_detalle_provider.dart';
import '../../domain/entities/oracion.dart';

class OracionDetallePage extends ConsumerWidget {
  final String slug;

  const OracionDetallePage({Key? key, required this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(oracionDetalleProvider(slug));

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: () {
        switch (detailState) {
          case DataStateInitial() || DataStateLoading():
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryColor));
          case DataStateError(message: final errorMsg):
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: AppColors.primaryRed),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'Error al cargar la oración.',
                      style: AppTheme.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      errorMsg,
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMedium
                          .copyWith(color: AppColors.mediumGray),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(oracionDetalleProvider(slug).notifier)
                          .loadDetalle(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          case DataStateSuccess(data: final prayer):
            return _buildDetailContent(context, prayer);
        }
      }(),
    );
  }

  Widget _buildDetailContent(BuildContext context, Oracion prayer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Título de la oración
          Text(
            prayer.titulo,
            style: AppTheme.headingLarge.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),

          // 2. Duración y metadatos
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.parishGold.withAlpha(38),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: AppColors.parishGold.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.menu_book,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${prayer.duracionEstimada} min de lectura',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),

          // 3. Descripción
          if (prayer.descripcion.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withAlpha(77),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppColors.mediumGray.withAlpha(26),
                  width: 1,
                ),
              ),
              child: Text(
                prayer.descripcion,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
          ],

          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: AppTheme.spacingL),

          // 4. Contenido Principal
          if (prayer.secciones.isEmpty)
            // Oración de texto simple
            _buildFlatContent(prayer.contenido ?? '')
          else
            // Oración con múltiples secciones (Liturgias estructuradas)
            _buildMultipartContent(prayer),

          const SizedBox(height: AppTheme.spacingXXL),
        ],
      ),
    );
  }

  Widget _buildFlatContent(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
        border: Border.all(
          color: AppColors.parishGold.withAlpha(38),
          width: 1,
        ),
      ),
      child: SelectableText(
        text,
        style: AppTheme.bodyLarge.copyWith(
          height: 1.6,
          fontSize: 16,
          color: Colors.black87,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildMultipartContent(Oracion prayer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pasos y Liturgia',
          style: AppTheme.headingSmall.copyWith(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prayer.secciones.length,
          itemBuilder: (context, index) {
            final seccion = prayer.secciones[index];
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacingXL),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.mediumShadow,
                border: Border.all(
                  color: AppColors.parishGold.withAlpha(38),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado de la sección
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                      vertical: AppTheme.spacingM,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.parishGold.withAlpha(38),
                          AppColors.parishGold.withAlpha(12),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusLarge),
                        topRight: Radius.circular(AppTheme.radiusLarge),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Círculo con el número de paso
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            gradient: AppColors.goldGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Text(
                            seccion.titulo,
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Contenido de la sección
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    child: SelectableText(
                      seccion.contenido,
                      style: AppTheme.bodyLarge.copyWith(
                        height: 1.6,
                        fontSize: 16,
                        color: Colors.black87,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
