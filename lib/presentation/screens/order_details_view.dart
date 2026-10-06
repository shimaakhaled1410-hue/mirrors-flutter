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
import '../widgets/order_details/order_details_items_card.dart';
import '../widgets/order_details/order_details_payment_card.dart';
import '../widgets/order_details/order_details_shipping_card.dart';
import '../widgets/order_details/order_details_status_card.dart';
import '../widgets/order_details/order_details_totals_card.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final currentOrder = state.orders.firstWhere(
          (o) => o.orderId == order.orderId,
          orElse: () => order,
        );

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
                child: OrderDetailsStatusCard(order: currentOrder),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                index: 1,
                child: OrderDetailsShippingCard(order: currentOrder),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                index: 2,
                child: OrderDetailsPaymentCard(order: currentOrder),
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
                child: OrderDetailsTotalsCard(order: currentOrder),
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