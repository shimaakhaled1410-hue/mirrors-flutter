import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/mirror_ui_model.dart';
import '../../../../l10n/app_localizations.dart';

class RetailSubCategoryFilter extends StatelessWidget {
  final RetailSubCategory? selectedFilter;
  final ValueChanged<RetailSubCategory?> onSelected;

  const RetailSubCategoryFilter({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filterOptions = [
      (label: l10n.filterAll, value: null),
      (label: l10n.filterStandard, value: RetailSubCategory.standard),
      (label: l10n.filterSpecialSizes, value: RetailSubCategory.specialSize),
      (label: l10n.filterWithShelf, value: RetailSubCategory.withShelf),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filterOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = filterOptions[index];
          final isSelected = selectedFilter == option.value;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onSelected(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Center(
                child: Text(
                  option.label,
                  style: isSelected
                      ? AppStyles.semiBold14(
                          context,
                        ).copyWith(color: Colors.white, fontSize: 12)
                      : AppStyles.medium14(context).copyWith(fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
