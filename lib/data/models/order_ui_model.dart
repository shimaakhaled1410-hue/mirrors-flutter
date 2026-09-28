import 'cart_item_model.dart';

enum OrderStatus {
  received(0),
  preparing(1),
  shipping(2),
  delivered(3);

  final int step;
  const OrderStatus(this.step);
}

class OrderUiModel {
  final String orderId;
  final String date;
  final int totalItems;
  final double totalPrice;
  final OrderStatus status;
  final String? customerName;
  final String? phoneNumber;
  final String? address;
  final String? paymentMethod;
  final List<CartItemModel> items;

  const OrderUiModel({
    required this.orderId,
    required this.date,
    required this.totalItems,
    required this.totalPrice,
    required this.status,
    this.customerName,
    this.phoneNumber,
    this.address,
    this.paymentMethod,
    this.items = const [],
  });

  OrderUiModel copyWith({
    String? orderId,
    String? date,
    int? totalItems,
    double? totalPrice,
    OrderStatus? status,
    String? customerName,
    String? phoneNumber,
    String? address,
    String? paymentMethod,
    List<CartItemModel>? items,
  }) {
    return OrderUiModel(
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
    );
  }
}

const List<OrderUiModel> kDummyOrders = [
  OrderUiModel(
    orderId: '1042',
    date: '2026-09-26',
    totalItems: 12,
    totalPrice: 1080,
    status: OrderStatus.preparing,
  ),
  OrderUiModel(
    orderId: '1035',
    date: '2026-09-20',
    totalItems: 2,
    totalPrice: 270,
    status: OrderStatus.delivered,
  ),
  OrderUiModel(
    orderId: '1019',
    date: '2026-09-12',
    totalItems: 24,
    totalPrice: 1920,
    status: OrderStatus.delivered,
  ),
];