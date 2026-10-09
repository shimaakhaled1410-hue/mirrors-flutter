import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mirrors_app/core/common/delivery_timeline_notice.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../data/models/order_ui_model.dart';
import '../../l10n/app_localizations.dart';
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

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(order.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        OrderUiModel currentOrder = order;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data != null) {
            currentOrder = OrderUiModel.fromJson(data);
          }
        }

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
              if (currentOrder.status != OrderStatus.cancelled &&
                  currentOrder.status != OrderStatus.delivered) ...[
                const SizedBox(height: 12),
                const FadeSlideIn(
                  index: 1,
                  child: DeliveryTimelineNotice(),
                ),
              ],
              const SizedBox(height: 16),
              FadeSlideIn(
                index: 2,
                child: OrderDetailsShippingCard(order: currentOrder),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                index: 3,
                child: OrderDetailsPaymentCard(order: currentOrder),
              ),
              const SizedBox(height: 16),
              if (currentOrder.items.isNotEmpty) ...[
                FadeSlideIn(
                  index: 4,
                  child: OrderDetailsItemsCard(order: currentOrder),
                ),
                const SizedBox(height: 16),
              ],
              FadeSlideIn(
                index: 5,
                child: OrderDetailsTotalsCard(order: currentOrder),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                index: 6,
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
                  index: 7,
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