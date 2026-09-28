import 'package:go_router/go_router.dart';
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
    ],
  );
}