import '../../l10n/app_localizations.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  received(0),
  depositConfirmed(1),
  preparing(2),
  shipping(3),
  delivered(4),
  cancelled(-1);

  final int step;
  const OrderStatus(this.step);

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.received:
        return l10n.statusReceived;
      case OrderStatus.depositConfirmed:
        return l10n.statusDepositConfirmed;
      case OrderStatus.preparing:
        return l10n.statusPreparing;
      case OrderStatus.shipping:
        return l10n.statusShipping;
      case OrderStatus.delivered:
        return l10n.statusDelivered;
      case OrderStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  String toJson() => name;

  static OrderStatus fromJson(String? json) => OrderStatus.values.firstWhere(
        (e) => e.name == json,
        orElse: () => OrderStatus.received,
      );
}

class OrderUiModel {
  final String orderId;
  final String? userId;
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
    this.userId,
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
    String? userId,
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
      userId: userId ?? this.userId,
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
        if (userId != null) 'userId': userId,
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
        if (senderWalletNumber != null)
          'senderWalletNumber': senderWalletNumber,
        if (notes != null) 'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
        'createdAtMillis':
            createdAtMillis ?? DateTime.now().millisecondsSinceEpoch,
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
      userId: json['userId'] as String?,
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