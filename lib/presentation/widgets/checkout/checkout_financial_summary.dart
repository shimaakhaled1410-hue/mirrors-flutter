import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../l10n/app_localizations.dart';

class CheckoutFinancialSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double total;
  final double depositPaid;
  final double remaining;

  const CheckoutFinancialSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.depositPaid,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subtotal, style: AppStyles.regular14(context)),
              Text(
                '${subtotal.toInt()} ${l10n.egp}',
                style: AppStyles.medium14(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.shippingFee, style: AppStyles.regular14(context)),
              Text(
                '${shippingFee.toInt()} ${l10n.egp}',
                style: AppStyles.medium14(context),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total, style: AppStyles.bold16(context)),
              Text(
                '${total.toInt()} ${l10n.egp}',
                style: AppStyles.bold16(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.depositPaidNow,
                style: AppStyles.semiBold16(context).copyWith(fontSize: 14),
              ),
              Text(
                '${depositPaid.toInt()} ${l10n.egp}',
                style: AppStyles.bold16Accent,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.remainingOnDelivery,
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(fontSize: 14, color: Colors.green),
              ),
              Text(
                '${remaining.toInt()} ${l10n.egp}',
                style: AppStyles.bold16(context).copyWith(color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
