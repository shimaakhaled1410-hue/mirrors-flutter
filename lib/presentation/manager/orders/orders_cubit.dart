import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
            .map((item) => OrderUiModel.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(orders: loadedOrders));
      } catch (_) {}
    }
  }

  Future<void> _saveOrders(List<OrderUiModel> orders) async {
    final rawJson = jsonEncode(orders.map((o) => o.toJson()).toList());
    await _prefs.setString(AppStorageKeys.savedOrders, rawJson);
  }

  String _generateUniqueOrderId() {
    final now = DateTime.now();
    final timeSegment = now.millisecondsSinceEpoch.toString().substring(8);
    final randomDigits = (100 + Random().nextInt(900)).toString();
    return '$timeSegment$randomDigits';
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

  Future<OrderUiModel> placeOrder({
    required List<CartItemModel> items,
    required double totalPrice,
    required double depositAmount,
    required double remainingAmount,
    required String customerName,
    required String phoneNumber,
    required String address,
    required String paymentMethod,
    String? senderWalletNumber,
    String? notes,
  }) async {
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    final generatedId = _generateUniqueOrderId();

    final cleanPhone = phoneNumber.trim();

    if (cleanPhone.isNotEmpty) {
      await _prefs.setString(AppStorageKeys.customerPhone, cleanPhone);
    }
    if (customerName.trim().isNotEmpty) {
      await _prefs.setString(AppStorageKeys.customerName, customerName.trim());
    }
    if (address.trim().isNotEmpty) {
      await _prefs.setString(AppStorageKeys.customerAddress, address.trim());
    }

    final newOrder = OrderUiModel(
      orderId: generatedId,
      date: formattedDate,
      totalItems: items.fold(0, (sum, item) => sum + item.quantity),
      totalPrice: totalPrice,
      depositAmount: depositAmount,
      remainingAmount: remainingAmount,
      status: OrderStatus.received,
      customerName: customerName.trim(),
      phoneNumber: cleanPhone,
      address: address.trim(),
      paymentMethod: paymentMethod,
      senderWalletNumber: senderWalletNumber?.trim(),
      notes: notes?.trim(),
      items: items,
      createdAtMillis: now.millisecondsSinceEpoch,
    );

    final updatedOrders = [newOrder, ...state.orders];
    emit(state.copyWith(orders: updatedOrders));
    await _saveOrders(updatedOrders);

    try {
      await _firestoreService.submitOrder(newOrder);
    } catch (_) {}

    return newOrder;
  }

  StreamSubscription<List<OrderUiModel>>? _ordersSubscription;

  void startListeningToCustomerOrders(String phone) {
    if (phone.isEmpty) return;
    _ordersSubscription?.cancel();
    _ordersSubscription = _firestoreService.getOrdersByPhoneStream(phone).listen(
      (firestoreOrders) {
        if (firestoreOrders.isNotEmpty) {
          emit(state.copyWith(orders: firestoreOrders));
          _saveOrders(firestoreOrders);
        }
      },
    );
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}