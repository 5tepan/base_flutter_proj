import 'dart:async';

import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/runner.dart';

void main() async {
  await runZonedGuarded(() async {
    await run(getConfig());
  }, CustomLogger.onError);
}

Config getConfig() {
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  switch (flavor) {
    case 'dev':
      return Config(
        apiUrlDomain: 'localhost',
        apiUrlRelativePath: '/api/',
        appMetricaApiKey: 'DEV_KEY',
      );
    case 'prod':
      return Config(
        apiUrlDomain: 'api.myapp.com',
        apiUrlRelativePath: '/api/',
        appMetricaApiKey: 'PROD_KEY',
      );
    default:
      throw Exception('Unknown flavor: $flavor');
  }
}
