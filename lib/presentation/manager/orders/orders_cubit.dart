import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:mirrors_app/data/models/cart_item_model.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/data/services/orders_firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final SharedPreferences _prefs;
  final OrdersFirestoreService _firestoreService;
  StreamSubscription<List<OrderUiModel>>? _ordersSubscription;
  late final String _deviceId;

  OrdersCubit(this._prefs, this._firestoreService)
    : super(const OrdersState(orders: [])) {
    _initDeviceGuestId();
    _loadSavedOrders();
    startListeningToDeviceOrders();
  }

  void _initDeviceGuestId() {
    String? id = _prefs.getString(AppStorageKeys.deviceGuestId);
    if (id == null || id.isEmpty) {
      final randomSegment = Random().nextInt(999999).toString().padLeft(6, '0');
      id = 'dev_${DateTime.now().millisecondsSinceEpoch}_$randomSegment';
      _prefs.setString(AppStorageKeys.deviceGuestId, id);
    }
    _deviceId = id;
  }

  String get deviceId => _deviceId;

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

  void startListeningToDeviceOrders() {
    _ordersSubscription?.cancel();
    _ordersSubscription = _firestoreService
        .getOrdersByUserIdStream(_deviceId)
        .listen((firestoreOrders) {
          if (firestoreOrders.isNotEmpty) {
            emit(state.copyWith(orders: firestoreOrders));
            _saveOrders(firestoreOrders);
          }
        });
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
      userId: _deviceId,
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

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
