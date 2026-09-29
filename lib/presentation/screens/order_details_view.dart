import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../data/models/order_ui_model.dart';
import '../../l10n/app_localizations.dart';
import '../manager/orders/orders_cubit.dart';
import '../manager/orders/orders_state.dart';
import '../widgets/order_details/order_details_cancel_button.dart';
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

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final currentOrder = state.orders.firstWhere(
          (o) => o.orderId == order.orderId,
          orElse: () => order,
        );

        final isCancelled = currentOrder.status == OrderStatus.cancelled;
        final canCancel = currentOrder.status == OrderStatus.received;

        return Scaffold(
          appBar: AppBar(
            title: Text('${l10n.orderNumber}${currentOrder.orderId}'),
            scrolledUnderElevation: 0,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
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
                            isCancelled
                                ? l10n.statusCancelled
                                : l10n.orderTrackingTitle,
                            style: AppStyles.semiBold16(context).copyWith(
                              color: isCancelled ? Colors.red : null,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              currentOrder.date,
                              style: AppStyles.regular12(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 4),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border),
                          ),
                          child: OrderProgressStepper(
                              currentStatus: currentOrder.status),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                index: 1,
                child: OrderDetailsShippingCard(order: currentOrder),
              ),
              const SizedBox(height: 16),
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
                          const Icon(Icons.account_balance_wallet_outlined,
                              color: AppColors.accent, size: 20),
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
                        value: currentOrder.paymentMethod ?? l10n.vodafoneCash,
                      ),
                      if (currentOrder.senderWalletNumber != null &&
                          currentOrder.senderWalletNumber!.isNotEmpty) ...[
                        const Divider(height: 16),
                        OrderDetailsInfoRow(
                          label: l10n.senderWalletLabel,
                          value: currentOrder.senderWalletNumber!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (currentOrder.items.isNotEmpty) ...[
                FadeSlideIn(
                  index: 3,
                  child: OrderDetailsItemsCard(order: currentOrder),
                ),
                const SizedBox(height: 16),
              ],
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
                          Text(l10n.total,
                              style: AppStyles.semiBold16(context)),
                          Text(
                            '${currentOrder.totalPrice.toInt()} ${l10n.egp}',
                            style: AppStyles.bold16(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.depositPaidLabel,
                              style: AppStyles.regular14(context)),
                          Text(
                            '${currentOrder.depositAmount.toInt()} ${l10n.egp}',
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
                            style: AppStyles.semiBold16(context)
                                .copyWith(color: Colors.green),
                          ),
                          Text(
                            '${currentOrder.remainingAmount.toInt()} ${l10n.egp}',
                            style: AppStyles.bold18(context)
                                .copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      customMessage:
                          l10n.orderSupportMessage(currentOrder.orderId),
                      errorMessage: l10n.whatsappError,
                    );
                  },
                  icon: const Icon(Icons.chat_rounded, size: 20),
                  label: Text(
                    l10n.contactSupport,
                    style: AppStyles.semiBold16(context).copyWith(
                      fontSize: 14,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              if (canCancel) ...[
                const SizedBox(height: 12),
                FadeSlideIn(
                  index: 6,
                  child: OrderDetailsCancelButton(order: currentOrder),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}