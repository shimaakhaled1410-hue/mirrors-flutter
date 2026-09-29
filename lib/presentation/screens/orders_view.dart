import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/core/widgets/empty_state_widget.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_cubit.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_state.dart';
import 'package:mirrors_app/presentation/widgets/orders/order_card.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final orders = state.orders;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: orders.isEmpty
              ? EmptyStateWidget(
                  key: const ValueKey('empty_orders'),
                  icon: Icons.receipt_long_rounded,
                  title: l10n.ordersEmptyTitle,
                  subtitle: l10n.ordersEmptySubtitle,
                  buttonText: l10n.browseCatalog,
                  onButtonPressed: () => context.go(AppRoutes.mainLayout),
                )
              : ListView.builder(
                  key: const ValueKey('orders_list'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 14,
                    bottom: 100,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return FadeSlideIn(
                      index: index,
                      child: OrderCard(
                        order: order,
                        onTap: () {
                          context.push(AppRoutes.orderDetails, extra: order);
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}