import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/model/entities/app_settings.dart';
import 'package:base_flutter_proj/core/network/connectivity_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final configProvider = Provider<Config>((ref) {
  throw UnimplementedError();
});

final internetMonitorProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  final initial = await connectivity.checkConnectivity();
  yield isConnected(initial);

  yield* connectivity.onConnectivityChanged.map(isConnected);
});

final connectivityCheckProvider = Provider<Future<bool>>((ref) async {
  final connectivity = Connectivity();
  final result = await connectivity.checkConnectivity();
  return isConnected(result);
});

final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError();
});

/// Настройки, загруженные при старте. Переопределяется в [runner.dart].
final appSettingsProvider = Provider<AppSettings>((ref) {
  throw UnimplementedError();
});

final codeLengthProvider = Provider<int>(
  (ref) => ref.watch(appSettingsProvider).codeLength,
);
