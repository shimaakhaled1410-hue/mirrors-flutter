import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';

enum PaymentMethod { cash, vodafoneCash, visa }

class CartSummaryWidget extends StatefulWidget {
  final double subtotal;
  final double shippingFee;
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.onCheckout,
  });

  @override
  State<CartSummaryWidget> createState() => _CartSummaryWidgetState();
}

class _CartSummaryWidgetState extends State<CartSummaryWidget> {
  PaymentMethod _selectedPayment = PaymentMethod.cash;

  double get _total => widget.subtotal + widget.shippingFee;

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
          // Order Summary breakdown
          _buildRow(context, l10n.subtotal, '${widget.subtotal.toInt()} ${l10n.egp}'),
          const SizedBox(height: 8),
          _buildRow(context, l10n.shippingFee, '${widget.shippingFee.toInt()} ${l10n.egp}'),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total, style: AppStyles.bold18(context)),
              Text('${_total.toInt()} ${l10n.egp}', style: AppStyles.bold16Accent),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Methods Selection
          Text(l10n.paymentMethod, style: AppStyles.semiBold16(context)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPaymentOption(
                context,
                title: l10n.cashOnDelivery,
                icon: Icons.payments_outlined,
                method: PaymentMethod.cash,
              ),
              _buildPaymentOption(
                context,
                title: l10n.vodafoneCash,
                icon: Icons.phone_android_rounded,
                method: PaymentMethod.vodafoneCash,
              ),
              _buildPaymentOption(
                context,
                title: l10n.visaCard,
                icon: Icons.credit_card_rounded,
              method: PaymentMethod.visa,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: widget.onCheckout,
              child: Text(
                l10n.checkout,
                style: AppStyles.semiBold16(context).copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.regular14(context)),
        Text(value, style: AppStyles.medium14(context)),
      ],
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required PaymentMethod method,
  }) {
    final isSelected = _selectedPayment == method;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _selectedPayment = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha:0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accent : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColors.accent : null),
            const SizedBox(width: 6),
            Text(
              title,
              style: isSelected
                  ? AppStyles.semiBold16(context).copyWith(fontSize: 12, color: AppColors.accent)
                  : AppStyles.regular12(context),
            ),
          ],
        ),
      ),
    );
  }
}