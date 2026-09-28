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
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : const [],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onTierSelected(tier),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: isSelected
                          ? AppStyles.semiBold16(
                              context,
                            ).copyWith(fontSize: 12, color: Colors.white)
                          : AppStyles.regular12(context),
                      child: Text(_getTierLabel(context, tier)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}