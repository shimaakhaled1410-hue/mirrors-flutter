import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class OrderCardBottomActions extends StatelessWidget {
  final bool isCancelled;
  final VoidCallback onTap;

  const OrderCardBottomActions({
    super.key,
    required this.isCancelled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isCancelled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.red.withValues(alpha: 0.1)
                  : const Color(0xFFFFF1F0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? Colors.red.withValues(alpha: 0.25)
                    : const Color(0xFFFFA39E),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: Color(0xFFCF1322),
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.statusCancelled,
                  style: AppStyles.medium14(context).copyWith(
                    color: const Color(0xFFCF1322),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        TextButton.icon(
          onPressed: onTap,
          iconAlignment: IconAlignment.end,
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
          ),
          label: Text(
            l10n.viewDetails,
            style: AppStyles.semiBold16(context).copyWith(
              fontSize: 12,
              color: AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}