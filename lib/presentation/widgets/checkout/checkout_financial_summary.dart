import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

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
    final green = isDark ? AppColors.success : const Color(0xFF1E8E4E);
    final ratio = total > 0 ? (depositPaid / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          _Row(
            label: l10n.subtotal,
            value: '${subtotal.toInt()} ${l10n.egp}',
            labelStyle: AppStyles.regular14(context),
            valueStyle: AppStyles.medium14(context),
          ),
          const SizedBox(height: 10),
          _Row(
            label: l10n.shippingFee,
            value: '${shippingFee.toInt()} ${l10n.egp}',
            labelStyle: AppStyles.regular14(context),
            valueStyle: AppStyles.medium14(context),
          ),
          const Divider(height: 24),
          _Row(
            label: l10n.total,
            value: '${total.toInt()} ${l10n.egp}',
            labelStyle: AppStyles.bold16(context),
            valueStyle: AppStyles.bold20(context),
          ),
          const SizedBox(height: 16),

          // How much of the total is covered by the deposit.
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: ratio),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: border,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const SizedBox(height: 14),
          // IntrinsicHeight: a stretching Row needs a bounded height, and inside
          // a Column in a ListView there isn't one.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _AmountTile(
                    label: l10n.depositPaidNow,
                    amount: '${depositPaid.toInt()} ${l10n.egp}',
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _AmountTile(
                    label: l10n.remainingOnDelivery,
                    amount: '${remaining.toInt()} ${l10n.egp}',
                    color: green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _Row({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _AmountTile extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _AmountTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.regular12(context),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: AppStyles.bold16(context).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}