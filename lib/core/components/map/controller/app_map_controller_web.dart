import 'dart:typed_data';

import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_marker.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_polyline.dart';
import 'package:flutter/material.dart';

typedef AppMapPointCallback = void Function(AppMapPoint point);
typedef AppMapCameraChangedCallback = void Function(AppMapCamera camera);

/// Web keeps the shared map API available while native Yandex MapKit is absent.
class AppMapController extends ChangeNotifier {
  GlobalKey? snapshotBoundaryKey;
  AppMapPointCallback? onMapTap;
  AppMapCameraChangedCallback? onCameraChanged;

  bool get isReady => false;
  bool get trafficVisible => false;
  AppMapCamera? get camera => null;

  void attach(Object mapWindow) {}
  void detach() {}
  void setGesturesEnabled(bool enabled) {}
  void moveTo(AppMapCamera camera, {bool animated = true}) {}
  void zoomBy(double delta) {}
  void zoomIn() {}
  void zoomOut() {}
  void resetNorth() {}
  void fitBounds(List<AppMapPoint> points, {bool animated = true}) {}
  void setNightMode(bool enabled) {}
  void setMapStyle(String? style) {}
  void setTrafficVisible(bool visible) {}
  void toggleTraffic() {}
  void setUserLocationVisible(bool visible) {}
  void setMarkers(
    List<AppMapMarker> markers, {
    bool clustered = false,
    double clusterRadius = 60,
    int clusterMinZoom = 15,
  }) {}
  void setPolylines(List<AppMapPolyline> polylines) {}
  void setPickPoint(AppMapPoint? point) {}
  Future<Uint8List?> takeSnapshot({double pixelRatio = 3}) async => null;
}
