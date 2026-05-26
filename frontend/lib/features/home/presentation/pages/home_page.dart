import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../providers/home_provider.dart';
import '../../domain/entities/home_section.dart';

/// Página principal de la aplicación
///
/// Dashboard con acceso rápido a todas las features y resúmenes dinámicos
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('dd MMMM yyyy', 'es').format(now);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            // Header con gradiente
            _buildHeader(context, formattedDate),

            // Espacio
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingL),
            ),

            // Grid de opciones modernas
            _buildSectionsGrid(context, ref, homeState),

            // Card especial del Santo del Día
            _buildSantoDelDiaCard(context, ref, homeState),

            // Espacio final
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingL),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildHeader(BuildContext context, String formattedDate) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280,
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppTheme.radiusXLarge),
                  bottomRight: Radius.circular(AppTheme.radiusXLarge),
                ),
              ),
            ),
            // Contenido del header
            Positioned(
              top: 50,
              left: AppTheme.spacingL,
              right: AppTheme.spacingL,
              child: Column(
                children: [
                  // Logo y título
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.2),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          child: Image.asset(
                            "assets/images/logoP.png",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingL),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Resucitado App",
                                style: AppTheme.headingMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                "Parroquia Cristo Resucitado",
                                style: AppTheme.bodyMedium.copyWith(
                                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Card de fecha flotante
            Positioned(
              bottom: 0,
              left: AppTheme.spacingL,
              right: AppTheme.spacingL,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  boxShadow: AppTheme.mediumShadow,
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  formattedDate,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppColors.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsGrid(
      BuildContext context, WidgetRef ref, HomeState homeState) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (homeState.sections.isEmpty) {
              // Mostrar cards por defecto mientras carga
              return _buildDefaultCard(context, index);
            }

            final section = homeState.sections[index];
            return _buildModernCard(context, section);
          },
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spacingM,
          mainAxisSpacing: AppTheme.spacingM,
          childAspectRatio: 0.85,
        ),
      ),
    );
  }

  Widget _buildDefaultCard(BuildContext context, int index) {
    final List<Map<String, dynamic>> defaultSections = [
      {
        'title': 'Lecturas del Día',
        'subtitle': 'Palabra de Dios',
        'icon': FontAwesomeIcons.bookBible,
        'route': '/lecturasDelDia',
      },
      {
        'title': 'Eventos',
        'subtitle': 'Vida parroquial',
        'icon': FontAwesomeIcons.calendarDays,
        'route': '/eventos',
      },
      {
        'title': 'Emisiones',
        'subtitle': 'Radio y transmisiones',
        'icon': FontAwesomeIcons.microphone,
        'route': '/emisiones',
      },
      {
        'title': 'Nuestra Parroquia',
        'subtitle': 'Historia y misión',
        'icon': FontAwesomeIcons.church,
        'route': '/nuestraParroquia',
      },
      {
        'title': 'Oficina Parroquial',
        'subtitle': 'Contacto y servicios',
        'icon': FontAwesomeIcons.handsPraying,
        'route': '/oficinaParroquial',
      },
      {
        'title': 'Horarios de Misa',
        'subtitle': 'Celebraciones',
        'icon': FontAwesomeIcons.cross,
        'route': '/horarios',
      },
    ];

    final data = defaultSections[index];
    final section = HomeSection(
      id: data['route'],
      title: data['title'],
      subtitle: data['subtitle'],
      icon: data['icon'],
      route: data['route'],
    );

    return _buildModernCard(context, section);
  }

  Widget _buildModernCard(BuildContext context, HomeSection section) {
    return GestureDetector(
      onTap: () => context.push(section.route),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: AppTheme.mediumShadow,
          border: Border.all(
            color: AppColors.parishGold.withAlpha(51),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono con badge de contador
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.parishGold.withAlpha(102),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.goldLight.withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      section.icon,
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Badge de contador
                if (section.itemCount != null && section.itemCount! > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        '${section.itemCount}',
                        style: AppTheme.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            // Título
            Text(
              section.title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacingXS),
            // Subtítulo
            Text(
              section.subtitle,
              style: AppTheme.caption.copyWith(
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSantoDelDiaCard(
      BuildContext context, WidgetRef ref, HomeState homeState) {
    final santoSummary = homeState.santoSummary;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: GestureDetector(
          onTap: () => context.push('/santoDelDia'),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.parishGold.withAlpha(38),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.mediumShadow,
              border: Border.all(
                color: AppColors.parishGold.withAlpha(77),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Icono destacado
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.parishGold.withAlpha(102),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.goldLight.withAlpha(102),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingL),
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Santo del Día',
                        style: AppTheme.headingSmall.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        santoSummary?.nombre ?? 'Cargando...',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Icono de flecha
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
