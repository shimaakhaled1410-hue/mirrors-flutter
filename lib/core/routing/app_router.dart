import 'package:go_router/go_router.dart';
import '../../presentation/screens/cart_view.dart';
import '../../presentation/screens/main_layout_view.dart';

class AppRouter {
  AppRouter._();

  static const String mainLayout = '/';
  static const String cart = '/cart';

  static final GoRouter router = GoRouter(
    initialLocation: mainLayout,
    routes: [
      GoRoute(
        path: mainLayout,
        builder: (context, state) => const MainLayoutView(),
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const CartView(),
      ),
    ],
  );
}