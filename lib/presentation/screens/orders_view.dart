import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/orders/order_cubit.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_state.dart';
import 'package:mirrors_app/presentation/widgets/orders/order_card.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final orders = state.orders;

        if (orders.isEmpty) {
          return Center(
            child: FadeSlideIn(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 38,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.ordersTab,
                    style: AppStyles.semiBold16(context),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
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
                  // TODO: Navigate to Order Details View
                },
              ),
            );
          },
        );
      },
    );
  }
}