// coverage:ignore-start
import 'package:launcher1/app/ui/main_app_builder.dart';
import 'package:launcher1/app/ui/main_app_runner.dart';

Future<void> main() async {
  const env = String.fromEnvironment('env', defaultValue: 'prod');
  const runner = MainAppRunner(env);
  final builder = MainAppBuilder();
  await runner.run(builder);
}
// coverage:ignore-end