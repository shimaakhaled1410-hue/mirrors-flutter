import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

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
  // Initial dummy items in cart
  final List<CartItemModel> _cartItems = [
    CartItemModel(
      id: 'c1',
      product: kDummyMirrors[0], // Framed 30*35
      quantity: 1,
      isWholesale: false,
      unitPrice: 150,
    ),
    CartItemModel(
      id: 'c2',
      product: kDummyMirrors[1], // Framed 28*30
      quantity: 12, // One Dozen Wholesale
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
      body: _cartItems.isEmpty
          ? Center(child: Text(l10n.emptyCart))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._cartItems.map(
                  (item) => CartItemCard(
                    item: item,
                    onIncrement: () {
                      setState(() {
                        final index = _cartItems.indexWhere(
                          (e) => e.id == item.id,
                        );
                        _cartItems[index] = item.copyWith(
                          quantity: item.quantity + 1,
                        );
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        if (item.quantity > 1) {
                          final index = _cartItems.indexWhere(
                            (e) => e.id == item.id,
                          );
                          _cartItems[index] = item.copyWith(
                            quantity: item.quantity - 1,
                          );
                        }
                      });
                    },
                    onRemove: () {
                      setState(() {
                        _cartItems.removeWhere((e) => e.id == item.id);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CartSummaryWidget(
                  subtotal: _subtotal,
                  shippingFee: _shippingFee,
                  onCheckout: () {
                    // TODO: Trigger order submission
                  },
                ),
              ],
            ),
    );
  }
}
