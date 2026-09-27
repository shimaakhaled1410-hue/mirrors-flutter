import 'package:go_router/go_router.dart';
import 'package:mirrors_app/presentation/screens/main_layout_view.dart';

class AppRouter {
  AppRouter._();

  static const String mainLayout = '/';

  static final GoRouter router = GoRouter(
    initialLocation: mainLayout,
    routes: [
      GoRoute(
        path: mainLayout,
        builder: (context, state) => const MainLayoutView(),
      ),
    ],
  );
}