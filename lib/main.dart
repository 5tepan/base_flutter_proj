import 'dart:async';

import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/runner.dart';

void main() async {
  await runZonedGuarded(() async {
    await run(
      Config(
        apiUrlDomain: 'localhost',
        apiUrlRelativePath: '/api/',
        appMetricaApiKey: '1111',
      ),
    );
  }, CustomLogger.onError);
}
