import '../../../data/models/order_ui_model.dart';

class OrdersState {
  final List<OrderUiModel> orders;

  const OrdersState({this.orders = const []});

  OrdersState copyWith({List<OrderUiModel>? orders}) {
    return OrdersState(orders: orders ?? this.orders);
  }
}
