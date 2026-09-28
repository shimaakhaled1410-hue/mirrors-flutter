import 'package:go_router/go_router.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/presentation/screens/order_details_view.dart';
import '../../presentation/screens/cart_view.dart';
import '../../presentation/screens/checkout_view.dart';
import '../../presentation/screens/main_layout_view.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.mainLayout,
    routes: [
      GoRoute(
        path: AppRoutes.mainLayout,
        builder: (context, state) => const MainLayoutView(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutView(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) {
          final order = state.extra as OrderUiModel;
          return OrderDetailsView(order: order);
        },
      ),
    ],
  );
}