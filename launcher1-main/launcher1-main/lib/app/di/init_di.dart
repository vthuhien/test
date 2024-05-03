import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:launcher1/app/di/init_di.config.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> initDi(String env) async {
  locator
    ..init(environment: env)
    ..registerSingleton<AppRouter>(AppRouter());
  // ..registerLazySingleton(() => AuthBloc);
}
