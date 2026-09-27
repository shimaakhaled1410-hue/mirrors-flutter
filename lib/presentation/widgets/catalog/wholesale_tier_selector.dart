import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../data/models/mirror_ui_model.dart';

class WholesaleTierSelector extends StatelessWidget {
  final WholesaleTier selectedTier;
  final ValueChanged<WholesaleTier> onTierSelected;

  const WholesaleTierSelector({
    super.key,
    required this.selectedTier,
    required this.onTierSelected,
  });

  String _getTierLabel(BuildContext context, WholesaleTier tier) {
    final l10n = AppLocalizations.of(context)!;
    switch (tier) {
      case WholesaleTier.quarterDozen:
        return l10n.quarterDozen;
      case WholesaleTier.halfDozen:
        return l10n.halfDozen;
      case WholesaleTier.oneDozen:
        return l10n.oneDozen;
      case WholesaleTier.oneAndHalfDozen:
        return l10n.oneAndHalfDozen;
      case WholesaleTier.twoDozens:
        return l10n.twoDozens;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: WholesaleTier.values.map((tier) {
          final isSelected = selectedTier == tier;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onTierSelected(tier),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accent
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  _getTierLabel(context, tier),
                  style: isSelected
                      ? AppStyles.semiBold16(context).copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        )
                      : AppStyles.regular12(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}