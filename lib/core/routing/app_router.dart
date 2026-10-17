import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/presentation/screens/mirror_wall_preview_screen.dart';
import 'package:mirrors_app/presentation/screens/order_details_view.dart';
import 'package:mirrors_app/presentation/splash_screen.dart';
import '../../presentation/screens/cart_view.dart';
import '../../presentation/screens/checkout_view.dart';
import '../../presentation/screens/main_layout_view.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainLayout,
        // Fade in from the splash instead of sliding.
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          child: const MainLayoutView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
        ),
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
      GoRoute(
        path: AppRoutes.mirrorWallPreview,
        builder: (context, state) {
          final mirror = state.extra as MirrorUiModel;
          return MirrorWallPreviewScreen(mirror: mirror);
        },
      ),
    ],
  );
}