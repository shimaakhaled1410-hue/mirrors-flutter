import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/mirror_ui_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState()) {
    _loadCart();
  }

  static const int kMinWholesaleQuantity = 3;
  static const int kWholesaleStep = 3;

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJsonString = prefs.getString(AppStorageKeys.cartStorageKey);
      if (cartJsonString != null && cartJsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(cartJsonString);
        final loadedItems = decodedList
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(items: loadedItems));
      }
    } catch (_) {}
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedString = jsonEncode(items.map((e) => e.toJson()).toList());
      await prefs.setString(AppStorageKeys.cartStorageKey, encodedString);
    } catch (_) {}
  }

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
    _saveCart(currentItems);
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
    _saveCart(currentItems);
  }

  void incrementQuantity(String cartItemId) {
    final updated = state.items.map((item) {
      if (item.id == cartItemId) {
        final step = item.isWholesale ? kWholesaleStep : 1;
        return item.copyWith(quantity: item.quantity + step);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
    _saveCart(updated);
  }

  void decrementQuantity(String cartItemId) {
    final updated = state.items.map((item) {
      if (item.id == cartItemId) {
        final step = item.isWholesale ? kWholesaleStep : 1;
        final minQty = item.isWholesale ? kMinWholesaleQuantity : 1;
        if (item.quantity - step >= minQty) {
          return item.copyWith(quantity: item.quantity - step);
        }
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updated));
    _saveCart(updated);
  }

  void removeItem(String cartItemId) {
    final updated = state.items.where((item) => item.id != cartItemId).toList();
    emit(state.copyWith(items: updated));
    _saveCart(updated);
  }

  void clearCart() {
    emit(const CartState(items: []));
    _saveCart(const []);
  }
}