import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mirrors_app/data/services/orders_firestore_service.dart';
import 'package:mirrors_app/firebase_options.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/manager/app_settings/app_settings_cubit.dart';
import 'presentation/manager/app_settings/app_settings_state.dart';
import 'presentation/manager/cart/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env");
  final prefs = await SharedPreferences.getInstance();

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppSettingsCubit(prefs)),
          BlocProvider(create: (_) => CartCubit()),
          BlocProvider(create: (_) => OrdersCubit(prefs, OrdersFirestoreService())),
        ],
        child: const MirrorsApp(),
      ),
    ),
  );
}

class MirrorsApp extends StatelessWidget {
  const MirrorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Mirrors App',
          debugShowCheckedModeBanner: false,
          locale: state.locale,
          builder: DevicePreview.appBuilder,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
