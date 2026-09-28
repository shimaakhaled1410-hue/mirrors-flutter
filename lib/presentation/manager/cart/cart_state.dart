import '../../../data/models/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }
}