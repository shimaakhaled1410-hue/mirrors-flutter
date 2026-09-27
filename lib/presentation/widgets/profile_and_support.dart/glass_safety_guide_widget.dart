import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class GlassSafetyGuideWidget extends StatelessWidget {
  const GlassSafetyGuideWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.safetyAndGuide,
                  style: AppStyles.semiBold16(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildTipRow(context, Icons.pan_tool_outlined, l10n.safetyTip1),
          const SizedBox(height: 10),
          _buildTipRow(context, Icons.cleaning_services_outlined, l10n.safetyTip2),
          const SizedBox(height: 10),
          _buildTipRow(context, Icons.hardware_outlined, l10n.safetyTip3),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, IconData icon, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppStyles.regular12(context).copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}