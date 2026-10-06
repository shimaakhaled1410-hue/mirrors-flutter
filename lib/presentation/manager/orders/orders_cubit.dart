import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../data/services/orders_firestore_service.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final SharedPreferences _prefs;
  final OrdersFirestoreService _firestoreService;

  OrdersCubit(this._prefs, this._firestoreService)
      : super(const OrdersState(orders: [])) {
    _loadSavedOrders();
  }

  void _loadSavedOrders() {
    final rawJson = _prefs.getString(AppStorageKeys.savedOrders);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(rawJson);
        final loadedOrders = decoded
            .map((item) =>
                OrderUiModel.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(orders: loadedOrders));
      } catch (_) {}
    }
  }

  Future<void> _saveOrders(List<OrderUiModel> orders) async {
    final rawJson = jsonEncode(orders.map((o) => o.toJson()).toList());
    await _prefs.setString(AppStorageKeys.savedOrders, rawJson);
  }

  Future<void> cancelOrder(String orderId) async {
    final updatedOrders = state.orders.map((order) {
      if (order.orderId == orderId) {
        return order.copyWith(status: OrderStatus.cancelled);
      }
      return order;
    }).toList();

    emit(state.copyWith(orders: updatedOrders));
    await _saveOrders(updatedOrders);

    try {
      await _firestoreService.updateOrderStatus(orderId, OrderStatus.cancelled);
    } catch (_) {}
  }

  Future<void> placeOrder({
    required List<CartItemModel> items,
    required double totalPrice,
    required double depositAmount,
    required double remainingAmount,
    required String customerName,
    required String phoneNumber,
    required String address,
    required String paymentMethod,
    required String senderWalletNumber,
    String? notes,
  }) async {
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final generatedId = (1050 + state.orders.length).toString();

    final newOrder = OrderUiModel(
      orderId: generatedId,
      date: formattedDate,
      totalItems: items.fold(0, (sum, item) => sum + item.quantity),
      totalPrice: totalPrice,
      depositAmount: depositAmount,
      remainingAmount: remainingAmount,
      status: OrderStatus.received,
      customerName: customerName,
      phoneNumber: phoneNumber,
      address: address,
      paymentMethod: paymentMethod,
      senderWalletNumber: senderWalletNumber,
      notes: notes,
      items: items,
      createdAtMillis: now.millisecondsSinceEpoch,
    );

    final updatedOrders = [newOrder, ...state.orders];
    emit(state.copyWith(orders: updatedOrders));
    await _saveOrders(updatedOrders);

    try {
      await _firestoreService.submitOrder(newOrder);
    } catch (_) {}
  }
}