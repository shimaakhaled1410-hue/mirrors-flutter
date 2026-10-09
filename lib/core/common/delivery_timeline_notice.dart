import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../l10n/app_localizations.dart';

class DeliveryTimelineNotice extends StatelessWidget {
  const DeliveryTimelineNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withValues(alpha: 0.7)
            : const Color(0xFFF9F7FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? border : AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          // 1. Delivery Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.deliveryTimelineTitle,
                      style: AppStyles.semiBold16(context).copyWith(
                        fontSize: 13,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.deliveryTimelineDesc,
                      style: AppStyles.regular12(context).copyWith(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          // 2. Cancellation Policy
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.orange : Colors.amber.shade800)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assignment_return_outlined,
                  color: isDark ? Colors.orange : Colors.amber.shade800,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cancellationPolicyTitle,
                      style: AppStyles.semiBold16(context).copyWith(
                        fontSize: 13,
                        color: isDark ? Colors.orange : Colors.amber.shade900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.cancellationPolicyDesc,
                      style: AppStyles.regular12(context).copyWith(
                        fontSize: 12,
                        height: 1.4,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}