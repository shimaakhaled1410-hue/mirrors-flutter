import 'cart_item_model.dart';

enum OrderStatus {
  received(0),
  preparing(1),
  shipping(2),
  delivered(3),
  cancelled(-1);

  final int step;
  const OrderStatus(this.step);

  String toJson() => name;

  static OrderStatus fromJson(String? json) => OrderStatus.values.firstWhere(
        (e) => e.name == json,
        orElse: () => OrderStatus.received,
      );
}

class OrderUiModel {
  final String orderId;
  final String date;
  final int totalItems;
  final double totalPrice;
  final double depositAmount;
  final double remainingAmount;
  final OrderStatus status;
  final String? customerName;
  final String? phoneNumber;
  final String? address;
  final String? paymentMethod;
  final String? senderWalletNumber;
  final String? notes;
  final List<CartItemModel> items;
  final int? createdAtMillis;

  const OrderUiModel({
    required this.orderId,
    required this.date,
    required this.totalItems,
    required this.totalPrice,
    this.depositAmount = 0.0,
    this.remainingAmount = 0.0,
    required this.status,
    this.customerName,
    this.phoneNumber,
    this.address,
    this.paymentMethod,
    this.senderWalletNumber,
    this.notes,
    this.items = const [],
    this.createdAtMillis,
  });

  OrderUiModel copyWith({
    String? orderId,
    String? date,
    int? totalItems,
    double? totalPrice,
    double? depositAmount,
    double? remainingAmount,
    OrderStatus? status,
    String? customerName,
    String? phoneNumber,
    String? address,
    String? paymentMethod,
    String? senderWalletNumber,
    String? notes,
    List<CartItemModel>? items,
    int? createdAtMillis,
  }) {
    return OrderUiModel(
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      totalItems: totalItems ?? this.totalItems,
      totalPrice: totalPrice ?? this.totalPrice,
      depositAmount: depositAmount ?? this.depositAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      senderWalletNumber: senderWalletNumber ?? this.senderWalletNumber,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'date': date,
        'totalItems': totalItems,
        'totalPrice': totalPrice,
        'depositAmount': depositAmount,
        'remainingAmount': remainingAmount,
        'status': status.toJson(),
        if (customerName != null) 'customerName': customerName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (address != null) 'address': address,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
        if (senderWalletNumber != null) 'senderWalletNumber': senderWalletNumber,
        if (notes != null) 'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
        'createdAtMillis': createdAtMillis ?? DateTime.now().millisecondsSinceEpoch,
      };

  factory OrderUiModel.fromJson(Map<String, dynamic> json) {
    final parsedItems = (json['items'] as List<dynamic>?)
            ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    final rawTotalItems = (json['totalItems'] as num?)?.toInt();
    final computedTotalItems = rawTotalItems ??
        parsedItems.fold<int>(0, (sum, item) => sum + item.quantity);

    return OrderUiModel(
      orderId: json['orderId']?.toString() ?? '',
      date: json['date'] as String? ?? '',
      totalItems: computedTotalItems,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      depositAmount: (json['depositAmount'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.fromJson(json['status'] as String?),
      customerName: json['customerName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      senderWalletNumber: json['senderWalletNumber'] as String?,
      notes: json['notes'] as String?,
      items: parsedItems,
      createdAtMillis: (json['createdAtMillis'] as num?)?.toInt(),
    );
  }
}

const List<OrderUiModel> kDummyOrders = [
  OrderUiModel(
    orderId: '1042',
    date: '2026-09-26',
    totalItems: 12,
    totalPrice: 1080,
    depositAmount: 540,
    remainingAmount: 540,
    status: OrderStatus.preparing,
  ),
  OrderUiModel(
    orderId: '1035',
    date: '2026-09-20',
    totalItems: 2,
    totalPrice: 270,
    depositAmount: 135,
    remainingAmount: 135,
    status: OrderStatus.delivered,
  ),
  OrderUiModel(
    orderId: '1019',
    date: '2026-09-12',
    totalItems: 24,
    totalPrice: 1920,
    depositAmount: 960,
    remainingAmount: 960,
    status: OrderStatus.delivered,
  ),
];