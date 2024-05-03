// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AllAppsMenuRoute.name: (routeData) {
      final args = routeData.argsAs<AllAppsMenuRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AllAppsMenuScreen(
          key: args.key,
          onlyUserApps: args.onlyUserApps,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LockRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LockScreen(),
      );
    },
  };
}

/// generated route for
/// [AllAppsMenuScreen]
class AllAppsMenuRoute extends PageRouteInfo<AllAppsMenuRouteArgs> {
  AllAppsMenuRoute({
    Key? key,
    required bool onlyUserApps,
    List<PageRouteInfo>? children,
  }) : super(
          AllAppsMenuRoute.name,
          args: AllAppsMenuRouteArgs(
            key: key,
            onlyUserApps: onlyUserApps,
          ),
          initialChildren: children,
        );

  static const String name = 'AllAppsMenuRoute';

  static const PageInfo<AllAppsMenuRouteArgs> page =
      PageInfo<AllAppsMenuRouteArgs>(name);
}

class AllAppsMenuRouteArgs {
  const AllAppsMenuRouteArgs({
    this.key,
    required this.onlyUserApps,
  });

  final Key? key;

  final bool onlyUserApps;

  @override
  String toString() {
    return 'AllAppsMenuRouteArgs{key: $key, onlyUserApps: $onlyUserApps}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LockScreen]
class LockRoute extends PageRouteInfo<void> {
  const LockRoute({List<PageRouteInfo>? children})
      : super(
          LockRoute.name,
          initialChildren: children,
        );

  static const String name = 'LockRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
