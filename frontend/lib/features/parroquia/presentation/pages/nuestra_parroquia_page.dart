import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/core.dart';
import '../providers/parroquia_provider.dart';

/// Página de Nuestra Parroquia
class NuestraParroquiaPage extends ConsumerWidget {
  const NuestraParroquiaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parroquiaProvider);

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
                  _buildSection(
                      'Historia', data.historia, FontAwesomeIcons.bookOpen),
                  _buildSection(
                      'Misión', data.mision, FontAwesomeIcons.bullseye),
                  _buildSection('Visión', data.vision, FontAwesomeIcons.eye),
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
        title: Text('Nuestra Parroquia',
            style: AppTheme.headingMedium.copyWith(color: Colors.white)),
        background: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
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
          Row(
            children: [
              FaIcon(icon, color: AppColors.primaryColor, size: 24),
              SizedBox(width: AppTheme.spacingM),
              Text(title,
                  style: AppTheme.headingSmall
                      .copyWith(color: AppColors.primaryColor)),
            ],
          ),
          SizedBox(height: AppTheme.spacingM),
          Text(content,
              style: AppTheme.bodyMedium.copyWith(color: AppColors.darkGray)),
        ],
      ),
    );
  }
}
