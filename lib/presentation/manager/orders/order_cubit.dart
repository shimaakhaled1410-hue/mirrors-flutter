import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_ui_model.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState(orders: kDummyOrders));

  void placeOrder({
    required List<CartItemModel> items,
    required double totalPrice,
    required String customerName,
    required String phoneNumber,
    required String address,
    required String paymentMethod,
  }) {
    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final generatedId = (1050 + state.orders.length).toString();

    final newOrder = OrderUiModel(
      orderId: generatedId,
      date: formattedDate,
      totalItems: items.fold(0, (sum, item) => sum + item.quantity),
      totalPrice: totalPrice,
      status: OrderStatus.received,
      customerName: customerName,
      phoneNumber: phoneNumber,
      address: address,
      paymentMethod: paymentMethod,
      items: items,
    );

    emit(state.copyWith(orders: [newOrder, ...state.orders]));
  }
}
