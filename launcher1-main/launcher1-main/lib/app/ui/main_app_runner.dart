import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/domain/app_builder.dart';
import 'package:launcher1/app/domain/app_runner.dart';

class MainAppRunner implements AppRunner {
  final String env;

  const MainAppRunner(this.env);

  @override
  Future<void> preloadData() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    Intl.systemLocale = await findSystemLocale();
    // await initializeDateFormatting();
    // Intl.systemLocale = await findSystemLocale();

    // init app
    await initDi(env);

    // // Returns a list of only those apps that have launch intent
    // List<Application> apps = await DeviceApps.getInstalledApplications(
    //   onlyAppsWithLaunchIntent: false,
    //   includeSystemApps: true,
    // );

    // for (var app in apps) {
    //   log('pn: ${app.packageName},\tname: ${app.appName},');
    // }
  }

  @override
  Future<void> run(AppBuilder appBuilder) async {
    await runZonedGuarded(
      () async {
        await preloadData();
        runApp(appBuilder.buildApp());
      },
      (error, stackTrace) {
        // Handle the error gracefully
        debugPrint('Error: $error');
        // You can log the error or send it to a crash reporting service
        // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      },
    );
  }
}
