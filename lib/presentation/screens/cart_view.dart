import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/core/widgets/empty_state_widget.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

import '../manager/cart/cart_cubit.dart';
import '../manager/cart/cart_state.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/cart_summary_widget.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  static const double _shippingFee = 50.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle), scrolledUnderElevation: 0),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final items = state.items;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: items.isEmpty
                ? EmptyStateWidget(
                    key: const ValueKey('empty_cart'),
                    icon: Icons.shopping_bag_outlined,
                    title: l10n.cartEmptyTitle,
                    subtitle: l10n.cartEmptySubtitle,
                    buttonText: l10n.startShopping,
                    onButtonPressed: () => context.go(AppRoutes.mainLayout),
                  )
                : ListView(
                    key: const ValueKey('items'),
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...items.asMap().entries.map(
                        (entry) => FadeSlideIn(
                          key: ValueKey(entry.value.id),
                          index: entry.key,
                          child: CartItemCard(
                            item: entry.value,
                            onIncrement: () =>
                                cartCubit.incrementQuantity(entry.value.id),
                            onDecrement: () =>
                                cartCubit.decrementQuantity(entry.value.id),
                            onRemove: () =>
                                cartCubit.removeItem(entry.value.id),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlideIn(
                        index: items.length,
                        child: CartSummaryWidget(
                          subtotal: state.subtotal,
                          shippingFee: _shippingFee,
                          onCheckout: () {
                            context.push(AppRoutes.checkout);
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}