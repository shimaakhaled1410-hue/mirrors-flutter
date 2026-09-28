import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/mirror_ui_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addRetailItem(MirrorUiModel product) {
    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id && !item.isWholesale,
    );

    if (existingIndex != -1) {
      final existing = currentItems[existingIndex];
      currentItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
    } else {
      currentItems.add(
        CartItemModel(
          id: '${product.id}_retail',
          product: product,
          quantity: 1,
          isWholesale: false,
          unitPrice: product.retailPrice,
        ),
      );
    }
    emit(state.copyWith(items: currentItems));
  }

  void addWholesaleBatch(MirrorUiModel product, int quantity) {
    final currentItems = List<CartItemModel>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id && item.isWholesale,
    );

    if (existingIndex != -1) {
      final existing = currentItems[existingIndex];
      currentItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      currentItems.add(
        CartItemModel(
          id: '${product.id}_wholesale',
          product: product,
          quantity: quantity,
          isWholesale: true,
          unitPrice: product.wholesalePrice,
        ),
      );
    }
    emit(state.copyWith(items: currentItems));
  }

  void incrementQuantity(String cartItemId) {
    final updated = state.items.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void decrementQuantity(String cartItemId) {
    final updated = state.items.map((item) {
      if (item.id == cartItemId && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void removeItem(String cartItemId) {
    final updated = state.items.where((item) => item.id != cartItemId).toList();
    emit(state.copyWith(items: updated));
  }

  void clearCart() {
    emit(const CartState(items: []));
  }
}