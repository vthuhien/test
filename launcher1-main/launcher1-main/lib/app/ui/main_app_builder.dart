import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/domain/app_builder.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';
import 'package:launcher1/gen/l10n/l10n.dart';

MaterialColor from(Color color) {
  return MaterialColor(color.value, <int, Color>{
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  });
}

class MainAppBuilder implements AppBuilder {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget buildApp() {
    final appRouter = locator<AppRouter>();
    const primaryColor = Colors.deepPurple;

    return _GlobalProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        key: navigatorKey,
        // debugShowCheckedModeBanner: false,

        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),

        theme: ThemeData(
          primarySwatch: from(primaryColor),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        localizationsDelegates: AppLocals.localizationsDelegates,
        supportedLocales: AppLocals.supportedLocales,
      ),
    );
  }
}

class _GlobalProviders extends StatelessWidget {
  const _GlobalProviders({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
