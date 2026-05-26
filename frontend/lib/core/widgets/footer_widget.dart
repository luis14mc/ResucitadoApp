import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../config/theme/app_theme.dart';

/// Widget de footer estándar para todas las páginas
///
/// Muestra enlaces a redes sociales y botón para regresar al inicio
class StandardFooter extends StatelessWidget {
  const StandardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    // Verificar si estamos en el home para no mostrar el botón de inicio
    final bool isHome = GoRouterState.of(context).uri.path == '/';

    return Container(
      // Antes: height fija (100/140) causaba RenderFlex overflow de 1px en
      // ciertas densidades. Ahora `minHeight` permite que el footer crezca
      // si el contenido lo necesita, sin desbordar.
      constraints: BoxConstraints(minHeight: isHome ? 104 : 144),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isHome) ...[
            TextButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_rounded, color: Colors.white, size: 20),
              label: Text(
                'VOLVER AL INICIO',
                style: AppTheme.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
          Text(
            'Síguenos en nuestras redes',
            style: AppTheme.caption.copyWith(
              color: const Color.fromRGBO(255, 255, 255, 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(FontAwesomeIcons.facebook, () {}),
              const SizedBox(width: AppTheme.spacingM),
              _buildSocialButton(FontAwesomeIcons.instagram, () {}),
              const SizedBox(width: AppTheme.spacingM),
              _buildSocialButton(FontAwesomeIcons.xTwitter, () {}),
              const SizedBox(width: AppTheme.spacingM),
              _buildSocialButton(FontAwesomeIcons.youtube, () {}),
              const SizedBox(width: AppTheme.spacingM),
              _buildSocialButton(FontAwesomeIcons.tiktok, () {}),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.3),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
