import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_ui_model.dart';

class OrdersFirestoreService {
  final CollectionReference _ordersRef = FirebaseFirestore.instance.collection(
    'orders',
  );

  Future<void> submitOrder(OrderUiModel order) async {
    await _ordersRef.doc(order.orderId).set(order.toJson());
  }

  Stream<List<OrderUiModel>> getAllOrdersStream() {
    return _ordersRef
        .orderBy('createdAtMillis', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    OrderUiModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  Stream<List<OrderUiModel>> getOrdersByPhoneStream(String phone) {
    return _ordersRef
        .where('phoneNumber', isEqualTo: phone)
        .orderBy('createdAtMillis', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    OrderUiModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _ordersRef.doc(orderId).update({'status': newStatus.toJson()});
  }
}
