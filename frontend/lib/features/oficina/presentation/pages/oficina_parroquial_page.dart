import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/core.dart';
import '../providers/oficina_provider.dart';

/// Página de Oficina Parroquial
class OficinaParroquialPage extends ConsumerWidget {
  const OficinaParroquialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(oficinaProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          switch (state) {
            DataStateInitial() || DataStateLoading() => SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor)),
              ),
            DataStateSuccess(:final data) => SliverList(
                delegate: SliverChildListDelegate([
                  _buildContactCard(data.direccion, data.telefono, data.email),
                  _buildHorariosCard(data.horarios),
                  _buildServiciosCard(data.servicios),
                  const SizedBox(height: 100),
                ]),
              ),
            DataStateError(:final message) => SliverFillRemaining(
                child: Center(child: Text(message)),
              ),
          },
        ],
      ),
      bottomNavigationBar: const StandardFooter(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Oficina Parroquial',
            style: AppTheme.headingMedium.copyWith(color: Colors.white)),
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(String direccion, String telefono, String email) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacingL),
      padding: EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contacto',
              style: AppTheme.headingSmall
                  .copyWith(color: AppColors.primaryColor)),
          SizedBox(height: AppTheme.spacingM),
          _buildInfoRow(FontAwesomeIcons.locationDot, direccion),
          _buildInfoRow(FontAwesomeIcons.phone, telefono),
          _buildInfoRow(FontAwesomeIcons.envelope, email),
        ],
      ),
    );
  }

  Widget _buildHorariosCard(Map<String, String> horarios) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacingL),
      padding: EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horarios de Atención',
              style: AppTheme.headingSmall
                  .copyWith(color: AppColors.primaryColor)),
          SizedBox(height: AppTheme.spacingM),
          ...horarios.entries.map((e) =>
              _buildInfoRow(FontAwesomeIcons.clock, '${e.key}: ${e.value}')),
        ],
      ),
    );
  }

  Widget _buildServiciosCard(List<String> servicios) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacingL),
      padding: EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Servicios',
              style: AppTheme.headingSmall
                  .copyWith(color: AppColors.primaryColor)),
          SizedBox(height: AppTheme.spacingM),
          ...servicios.map((s) => _buildInfoRow(FontAwesomeIcons.check, s)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
          FaIcon(icon, color: AppColors.mediumGray, size: 16),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
              child: Text(text,
                  style:
                      AppTheme.bodyMedium.copyWith(color: AppColors.darkGray))),
        ],
      ),
    );
  }
}
