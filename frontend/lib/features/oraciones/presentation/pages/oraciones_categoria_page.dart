import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../providers/oraciones_provider.dart';
import '../../domain/entities/oracion.dart';

class OracionesCategoriaPage extends ConsumerWidget {
  final String categoria;

  const OracionesCategoriaPage({Key? key, required this.categoria}) : super(key: key);

  String _getCategoryTitle(String cat) {
    switch (cat.toLowerCase()) {
      case 'lectio_divina':
        return 'Lectio Divina';
      case 'liturgia_horas':
        return 'Liturgia de las Horas';
      case 'rosario':
        return 'Santo Rosario';
      case 'coronilla':
        return 'Coronilla';
      case 'basicas':
        return 'Oraciones Básicas';
      case 'intenciones':
        return 'Oraciones por Intención';
      case 'novenas':
        return 'Novenas';
      default:
        return 'Oraciones';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(oracionesCategoriaProvider(categoria));
    final String title = _getCategoryTitle(categoria);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          title,
          style: AppTheme.headingMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: RefreshIndicator(
        onRefresh: () => ref.read(oracionesCategoriaProvider(categoria).notifier).loadPorCategoria(),
        child: () {
          switch (listState) {
            case DataStateInitial() || DataStateLoading():
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
            case DataStateError(message: final errorMsg):
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: AppColors.primaryRed),
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        'Error al cargar las oraciones.',
                        style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(
                        errorMsg,
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyMedium.copyWith(color: AppColors.mediumGray),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      ElevatedButton(
                        onPressed: () => ref.read(oracionesCategoriaProvider(categoria).notifier).loadPorCategoria(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            case DataStateSuccess(data: final prayers):
              if (prayers.isEmpty) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppTheme.spacingXL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty, size: 80, color: AppColors.parishGold.withAlpha(128)),
                        const SizedBox(height: AppTheme.spacingL),
                        Text(
                          'No hay oraciones disponibles por el momento.',
                          textAlign: TextAlign.center,
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppColors.mediumGray,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              itemCount: prayers.length,
              itemBuilder: (context, index) {
                final prayer = prayers[index];
                return _buildOracionTile(context, prayer);
              },
            );
          }
        }(),
      ),
    );
  }

  Widget _buildOracionTile(BuildContext context, Oracion prayer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
        border: Border.all(
          color: AppColors.parishGold.withAlpha(38),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingL,
          vertical: AppTheme.spacingS,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                prayer.titulo,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.parishGold.withAlpha(38),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${prayer.duracionEstimada} min',
                style: AppTheme.caption.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppTheme.spacingXS),
          child: Text(
            prayer.descripcion,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.primaryColor,
        ),
        onTap: () => context.push('/oraciones/${prayer.slug}'),
      ),
    );
  }
}
