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
}