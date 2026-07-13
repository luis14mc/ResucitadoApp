import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../providers/oraciones_provider.dart';
import '../../domain/entities/oracion.dart';

class OracionesPage extends ConsumerWidget {
  const OracionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destacadasState = ref.watch(oracionesDestacadasProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Oraciones y Devocional',
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
      body: CustomScrollView(
        slivers: [
          // Espacio inicial
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingL)),

          // 1. Carrusel de Oraciones Destacadas
          _buildDestacadasSliver(context, destacadasState),

          // 2. Título de Categorías
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
              child: Text(
                'Categorías Oracionales',
                style: AppTheme.headingSmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingM)),

          // 3. Grid de Categorías
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingM,
                mainAxisSpacing: AppTheme.spacingM,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _buildCategoriaCard(
                  context,
                  title: 'Lectio Divina',
                  subtitle: 'Lectura orante',
                  icon: FontAwesomeIcons.bookOpen,
                  categoryKey: 'lectio_divina',
                  color: const Color(0xFF1E88E5),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Horas Litúrgicas',
                  subtitle: 'Completas y más',
                  icon: FontAwesomeIcons.clock,
                  categoryKey: 'liturgia_horas',
                  color: const Color(0xFFD81B60),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Santo Rosario',
                  subtitle: 'Contemplación',
                  icon: FontAwesomeIcons.circleDot,
                  categoryKey: 'rosario',
                  color: const Color(0xFF8E24AA),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Coronilla',
                  subtitle: 'Misericordia',
                  icon: FontAwesomeIcons.cross,
                  categoryKey: 'coronilla',
                  color: const Color(0xFF3949AB),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Básicas',
                  subtitle: 'Devocionario',
                  icon: FontAwesomeIcons.handsPraying,
                  categoryKey: 'basicas',
                  color: const Color(0xFF43A047),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Por Intención',
                  subtitle: 'Peticiones',
                  icon: FontAwesomeIcons.solidHeart,
                  categoryKey: 'intenciones',
                  color: const Color(0xFFE53935),
                ),
                _buildCategoriaCard(
                  context,
                  title: 'Novenas',
                  subtitle: 'Nueve días',
                  icon: FontAwesomeIcons.calendar,
                  categoryKey: 'novenas',
                  color: const Color(0xFFFB8C00),
                ),
              ]),
            ),
          ),

          // Espacio final
          const SliverToBoxAdapter(child: SizedBox(height: AppTheme.spacingXXL)),
        ],
      ),
    );
  }

  Widget _buildDestacadasSliver(BuildContext context, DataState<List<Oracion>> state) {
    switch (state) {
      case DataStateInitial() || DataStateLoading():
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingL),
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          ),
        );
      case DataStateError():
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      case DataStateSuccess(data: final prayers):
        if (prayers.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                child: Text(
                  'Recomendadas',
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  itemCount: prayers.length,
                  itemBuilder: (context, index) {
                    final prayer = prayers[index];
                    return _buildDestacadaCard(context, prayer);
                  },
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        );
    }
  }

  Widget _buildDestacadaCard(BuildContext context, Oracion prayer) {
    return GestureDetector(
      onTap: () => context.push('/oraciones/${prayer.slug}'),
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXS, vertical: AppTheme.spacingXS),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.parishGold.withAlpha(26),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.mediumShadow,
          border: Border.all(
            color: AppColors.parishGold.withAlpha(77),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.parishGold.withAlpha(51),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${prayer.duracionEstimada} min de lectura',
                style: AppTheme.caption.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              prayer.titulo,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              prayer.descripcion,
              style: AppTheme.caption.copyWith(
                color: AppColors.mediumGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String categoryKey,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => context.push('/oraciones/categoria/$categoryKey'),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.mediumShadow,
          border: Border.all(
            color: color.withAlpha(38),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.caption.copyWith(
                    color: AppColors.mediumGray,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
