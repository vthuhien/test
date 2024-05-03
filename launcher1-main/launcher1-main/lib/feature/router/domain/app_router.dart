import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:launcher1/app/ui/screen/all_apps_menu_screen.dart';
import 'package:launcher1/app/ui/screen/home_screen.dart';
import 'package:launcher1/app/ui/screen/lock_screen.dart';
import 'package:launcher1/feature/router/presentation/anim/fade_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          barrierColor: Colors.black,
          path: LockScreen.path,
          page: LockRoute.page,
          initial: true,
          keepHistory: false,
          transitionsBuilder: _fadeAnim,
        ),
        CustomRoute(
          barrierColor: Colors.black,
          path: HomeScreen.path,
          page: HomeRoute.page,
          transitionsBuilder: _fadeAnim,
        ),
        CustomRoute(
          barrierColor: Colors.black,
          path: AllAppsMenuScreen.path,
          page: AllAppsMenuRoute.page,
          transitionsBuilder: _fadeAnim,
        ),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];

  Widget _fadeAnim(context, animation, secondaryAnimation, child) =>
      FadeRoute(builder: (context) => child).buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
}
