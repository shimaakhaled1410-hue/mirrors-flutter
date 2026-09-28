import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/presentation/widgets/orders/order_card.dart';
import '../../data/models/order_ui_model.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 100),
      itemCount: kDummyOrders.length,
      itemBuilder: (context, index) {
        final order = kDummyOrders[index];
        return FadeSlideIn(
          index: index,
          child: OrderCard(
            order: order,
            onTap: () {
              // TODO: Navigate to Order Details View
            },
          ),
        );
      },
    );
  }
}