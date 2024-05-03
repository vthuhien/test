import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/ui/components/apps_grid.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';
import 'package:launcher1/feature/status_bar/ui/status_bar.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  static const String path = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        locator.get<AppRouter>().replace(const LockRoute());
        return false;
      },
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            StatusBar(showClock: true),
            Expanded(child: AppsGrid()),
          ],
        ),
      ),
    );
  }
}
