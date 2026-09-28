import 'mirror_ui_model.dart';

class CartItemModel {
  final String id;
  final MirrorUiModel product;
  final int quantity;
  final bool isWholesale;
  final double unitPrice;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.isWholesale,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    MirrorUiModel? product,
    int? quantity,
    bool? isWholesale,
    double? unitPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isWholesale: isWholesale ?? this.isWholesale,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'quantity': quantity,
        'isWholesale': isWholesale,
        'unitPrice': unitPrice,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String,
        product: MirrorUiModel.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        isWholesale: json['isWholesale'] as bool,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}