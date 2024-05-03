import 'package:flutter/widgets.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';
import 'package:launcher1/gen/l10n/l10n.dart';

// ignore: prefer-match-file-name
class AppLang {
  static AppLocals get loc =>
      AppLocals.of(locator.get<AppRouter>().navigatorKey.currentContext!);
}

extension L10nHelper on BuildContext {
  AppLocals get l10n => AppLocals.of(this);
}
