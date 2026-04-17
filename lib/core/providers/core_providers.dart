import 'package:base_flutter_proj/core/config.dart';
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

class AuthStatusNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setAuthorized(bool value) {
    state = value;
  }
}

final authStatusProvider = NotifierProvider<AuthStatusNotifier, bool>(
  AuthStatusNotifier.new,
);
