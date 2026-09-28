import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
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
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            context,
            l10n.subtotal,
            '${widget.subtotal.toInt()} ${l10n.egp}',
          ),
          const SizedBox(height: 10),
          _buildRow(
            context,
            l10n.shippingFee,
            '${widget.shippingFee.toInt()} ${l10n.egp}',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withValues(alpha: 0.16),
                  AppColors.accent.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.total, style: AppStyles.bold18(context)),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    '${_total.toInt()} ${l10n.egp}',
                    key: ValueKey(_total.toInt()),
                    style: AppStyles.bold18(
                      context,
                    ).copyWith(color: AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l10n.paymentMethod, style: AppStyles.semiBold16(context)),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: PressableScale(
              pressedScale: 0.98,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: widget.onCheckout,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.checkout,
                            style: AppStyles.semiBold16(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: AppColors.accent,
                            // matchTextDirection: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accent.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.accent
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              _selectedPayment = method;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: isSelected ? AppColors.accent : null,
                ),
                const SizedBox(width: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: isSelected
                      ? AppStyles.semiBold16(
                          context,
                        ).copyWith(fontSize: 12, color: AppColors.accent)
                      : AppStyles.regular12(context),
                  child: Text(title),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: isSelected
                      ? const Padding(
                          padding: EdgeInsetsDirectional.only(start: 6),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 15,
                            color: AppColors.accent,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}