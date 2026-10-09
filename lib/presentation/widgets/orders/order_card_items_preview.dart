import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class OrderCardItemsPreview extends StatelessWidget {
  final OrderUiModel order;
  final bool isCancelled;

  const OrderCardItemsPreview({
    super.key,
    required this.order,
    required this.isCancelled,
  });

  String _buildItemsSummary(BuildContext context, AppLocalizations l10n) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final mirrorWord = isAr ? 'مرآة' : 'Mirror';
    final unit = isAr ? 'سم' : 'cm';
    final otherWord = isAr ? 'أخرى' : 'other';

    if (order.items.isEmpty) {
      return '${order.totalItems} ${l10n.items}';
    }

    final firstProduct = order.items.first.product;
    final firstItemTitle = '$mirrorWord ${firstProduct.dimensions} $unit';
    final otherItemsCount = order.items.length - 1;

    if (otherItemsCount > 0) {
      return '$firstItemTitle + $otherItemsCount $otherWord';
    }
    return firstItemTitle;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withValues(alpha: 0.6)
            : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 16,
            color: isCancelled ? secondary : AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildItemsSummary(context, l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.medium14(context).copyWith(fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border.withValues(alpha: 0.5)),
            ),
            child: Text(
              '${order.totalItems} ${l10n.items}',
              style: AppStyles.semiBold16(
                context,
              ).copyWith(fontSize: 11, color: secondary),
            ),
          ),
        ],
      ),
    );
  }
}
