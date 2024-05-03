import 'l10n.dart';

/// The translations for Russian (`ru`).
class AppLocalsRu extends AppLocals {
  AppLocalsRu([String locale = 'ru']) : super(locale);

  @override
  String get downloading => 'Загрузка...';

  @override
  String get loading => 'Загрузка...';

  @override
  String get pressStar => 'Нажм. *';

  @override
  String get test => 'тест';

  @override
  String get unlock => 'Разблок.';

  @override
  String get update => 'Обновление';
}
