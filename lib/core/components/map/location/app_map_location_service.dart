import 'package:app_settings/app_settings.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';
import 'package:base_flutter_proj/core/platform/app_platform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Результат запроса геопозиции устройства.
sealed class AppMapLocationResult {
  const AppMapLocationResult();
}

class AppMapLocationSuccess extends AppMapLocationResult {
  const AppMapLocationSuccess(this.point);

  final AppMapPoint point;
}

class AppMapLocationDenied extends AppMapLocationResult {
  const AppMapLocationDenied({this.permanently = false});

  final bool permanently;
}

class AppMapLocationServiceDisabled extends AppMapLocationResult {
  const AppMapLocationServiceDisabled();
}

class AppMapLocationUnavailable extends AppMapLocationResult {
  const AppMapLocationUnavailable([this.message]);

  final String? message;
}

/// Геолокация через geolocator + permission_handler (не Geocoder API).
class AppMapLocationService {
  const AppMapLocationService();

  Future<AppMapLocationResult> getCurrentPosition() async {
    if (!AppPlatform.isMobile) {
      return const AppMapLocationUnavailable('Location is mobile-only');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const AppMapLocationServiceDisabled();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final status = await ph.Permission.locationWhenInUse.request();
      if (status.isPermanentlyDenied) {
        return const AppMapLocationDenied(permanently: true);
      }
      if (!status.isGranted) {
        return const AppMapLocationDenied();
      }
      permission = await Geolocator.checkPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return const AppMapLocationDenied(permanently: true);
    }
    if (permission == LocationPermission.denied) {
      return const AppMapLocationDenied();
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return AppMapLocationSuccess(
        AppMapPoint(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } catch (error) {
      return AppMapLocationUnavailable(error.toString());
    }
  }

  Future<void> openAppSettings() {
    return AppSettings.openAppSettings();
  }

  Future<void> openLocationSettings() {
    return AppSettings.openAppSettings(type: AppSettingsType.location);
  }
}
