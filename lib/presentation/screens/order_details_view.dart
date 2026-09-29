import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/whatsapp_helper.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../data/models/order_ui_model.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/order_details/order_details_info_row.dart';
import '../widgets/order_details/order_details_items_card.dart';
import '../widgets/order_details/order_details_shipping_card.dart';
import '../widgets/orders/order_progress_stepper.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderNumber}${order.orderId}'),
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Order Status Stepper
          FadeSlideIn(
            index: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.orderTrackingTitle,
                        style: AppStyles.semiBold16(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: border),
                        ),
                        child: Text(
                          order.date,
                          style: AppStyles.regular12(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: OrderProgressStepper(currentStatus: order.status),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Shipping Details
          FadeSlideIn(index: 1, child: OrderDetailsShippingCard(order: order)),
          const SizedBox(height: 16),

          // 3. Payment & Deposit Details
          FadeSlideIn(
            index: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.depositAndPaymentDetails,
                        style: AppStyles.semiBold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  OrderDetailsInfoRow(
                    label: l10n.paymentMethod,
                    value: order.paymentMethod ?? l10n.vodafoneCash,
                  ),
                  if (order.senderWalletNumber != null &&
                      order.senderWalletNumber!.isNotEmpty) ...[
                    const Divider(height: 16),
                    OrderDetailsInfoRow(
                      label: l10n.senderWalletLabel,
                      value: order.senderWalletNumber!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. Products List
          if (order.items.isNotEmpty) ...[
            FadeSlideIn(index: 3, child: OrderDetailsItemsCard(order: order)),
            const SizedBox(height: 16),
          ],

          // 5. Financial Summary
          FadeSlideIn(
            index: 4,
            child: Container(
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
                      Text(l10n.total, style: AppStyles.semiBold16(context)),
                      Text(
                        '${order.totalPrice.toInt()} ${l10n.egp}',
                        style: AppStyles.bold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.depositPaidLabel,
                        style: AppStyles.regular14(context),
                      ),
                      Text(
                        '${order.depositAmount.toInt()} ${l10n.egp}',
                        style: AppStyles.bold16Accent,
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.remainingOnDelivery,
                        style: AppStyles.semiBold16(
                          context,
                        ).copyWith(color: Colors.green),
                      ),
                      Text(
                        '${order.remainingAmount.toInt()} ${l10n.egp}',
                        style: AppStyles.bold18(
                          context,
                        ).copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Contact Support Button
          FadeSlideIn(
            index: 5,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                WhatsAppHelper.openChat(
                  context: context,
                  customMessage: l10n.orderSupportMessage(order.orderId),
                  errorMessage: l10n.whatsappError,
                );
              },
              icon: const Icon(Icons.chat_rounded, size: 20),
              label: Text(
                l10n.contactSupport,
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(fontSize: 14, color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
