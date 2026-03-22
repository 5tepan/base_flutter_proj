import 'package:connectivity_plus/connectivity_plus.dart';

bool isConnected(List<ConnectivityResult> results) {
  return results.contains(ConnectivityResult.mobile) ||
      results.contains(ConnectivityResult.wifi) ||
      results.contains(ConnectivityResult.ethernet);
}
