import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_styles.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/mirror_ui_model.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/cart_summary_widget.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final List<CartItemModel> _cartItems = [
    CartItemModel(
      id: 'c1',
      product: kDummyMirrors[0],
      quantity: 1,
      isWholesale: false,
      unitPrice: 150,
    ),
    CartItemModel(
      id: 'c2',
      product: kDummyMirrors[1],
      quantity: 12,
      isWholesale: true,
      unitPrice: 90,
    ),
  ];

  double get _subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  final double _shippingFee = 50.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle), scrolledUnderElevation: 0),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _cartItems.isEmpty
            ? Center(
                key: const ValueKey('empty'),
                child: FadeSlideIn(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 42,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(l10n.emptyCart, style: AppStyles.semiBold16(context)),
                    ],
                  ),
                ),
              )
            : ListView(
                key: const ValueKey('items'),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  ..._cartItems.asMap().entries.map(
                    (entry) => FadeSlideIn(
                      key: ValueKey(entry.value.id),
                      index: entry.key,
                      child: CartItemCard(
                        item: entry.value,
                        onIncrement: () {
                          setState(() {
                            final index = _cartItems.indexWhere(
                              (e) => e.id == entry.value.id,
                            );
                            _cartItems[index] = entry.value.copyWith(
                              quantity: entry.value.quantity + 1,
                            );
                          });
                        },
                        onDecrement: () {
                          setState(() {
                            if (entry.value.quantity > 1) {
                              final index = _cartItems.indexWhere(
                                (e) => e.id == entry.value.id,
                              );
                              _cartItems[index] = entry.value.copyWith(
                                quantity: entry.value.quantity - 1,
                              );
                            }
                          });
                        },
                        onRemove: () {
                          setState(() {
                            _cartItems.removeWhere(
                              (e) => e.id == entry.value.id,
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeSlideIn(
                    index: _cartItems.length,
                    child: CartSummaryWidget(
                      subtotal: _subtotal,
                      shippingFee: _shippingFee,
                      onCheckout: () {
                        // TODO: Trigger order submission
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}