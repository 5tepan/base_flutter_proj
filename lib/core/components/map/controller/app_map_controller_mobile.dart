import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:base_flutter_proj/core/components/map/clustering/app_map_cluster_manager.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_marker.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_polyline.dart';
import 'package:flutter/material.dart' hide Animation;
import 'package:flutter/rendering.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart' hide Map;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as mk show Map;
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';

typedef AppMapPointCallback = void Function(AppMapPoint point);
typedef AppMapCameraChangedCallback = void Function(AppMapCamera camera);

/// Контроллер поверх MapKit MapWindow (markers, camera, traffic, snapshot).
class AppMapController extends ChangeNotifier {
  MapWindow? _mapWindow;
  TrafficLayer? _trafficLayer;
  UserLocationLayer? _userLocationLayer;
  AppMapClusterManager? _clusterManager;
  ClusterizedPlacemarkCollection? _clusterCollection;
  MapObjectCollection? _markersCollection;
  final Map<String, PolylineMapObject> _polylines = {};
  PlacemarkMapObject? _pickPlacemark;

  /// Для снимка через [RepaintBoundary] в [AppMapView].
  GlobalKey? snapshotBoundaryKey;

  _MapTapListener? _inputListener;
  _MapCameraListener? _cameraListener;
  MapSizeChangedListener? _pendingSizeListener;

  bool _trafficVisible = false;
  bool _isReady = false;

  double _clusterRadius = 60;
  int _clusterMinZoom = 15;

  AppMapPointCallback? onMapTap;
  AppMapCameraChangedCallback? onCameraChanged;

  bool get isReady => _isReady;

  bool get trafficVisible => _trafficVisible;

  AppMapCamera? get camera {
    final map = _mapWindow?.map;
    if (map == null) {
      return null;
    }
    return _toAppCamera(map.cameraPosition);
  }

  void attach(MapWindow mapWindow) {
    detach();
    _mapWindow = mapWindow;
    final map = mapWindow.map;

    _inputListener = _MapTapListener((point) {
      onMapTap?.call(point);
    });
    map.addInputListener(_inputListener!);

    _cameraListener = _MapCameraListener((camera) {
      onCameraChanged?.call(camera);
      notifyListeners();
    });
    map.addCameraListener(_cameraListener!);

    _trafficLayer = mapkit.createTrafficLayer(mapWindow);
    _userLocationLayer = mapkit.createUserLocationLayer(mapWindow);
    _userLocationLayer?.setVisible(false);

    _markersCollection = map.mapObjects.addCollection();
    _isReady = true;
    notifyListeners();
  }

  void detach() {
    _clearPendingSizeListener();
    final map = _mapWindow?.map;
    if (map != null) {
      if (_inputListener != null) {
        map.removeInputListener(_inputListener!);
      }
      if (_cameraListener != null) {
        map.removeCameraListener(_cameraListener!);
      }
    }
    _inputListener = null;
    _cameraListener = null;
    _mapWindow = null;
    _trafficLayer = null;
    _userLocationLayer = null;
    _clusterManager = null;
    _clusterCollection = null;
    _markersCollection = null;
    _polylines.clear();
    _pickPlacemark = null;
    _isReady = false;
  }

  void _clearPendingSizeListener() {
    final window = _mapWindow;
    final listener = _pendingSizeListener;
    if (window != null && listener != null) {
      window.removeSizeChangedListener(listener);
    }
    _pendingSizeListener = null;
  }

  void setGesturesEnabled(bool enabled) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }
    map
      ..scrollGesturesEnabled = enabled
      ..zoomGesturesEnabled = enabled
      ..tiltGesturesEnabled = enabled
      ..rotateGesturesEnabled = enabled;
  }

  void moveTo(
    AppMapCamera camera, {
    bool animated = true,
  }) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }
    map.move(
      _toNativeCamera(camera),
      animation: animated
          ? const Animation(type: AnimationType.Smooth, duration: 0.35)
          : const Animation(),
    );
  }

  void zoomBy(double delta) {
    final current = camera;
    if (current == null) {
      return;
    }
    moveTo(current.copyWith(zoom: (current.zoom + delta).clamp(0, 21)));
  }

  void zoomIn() => zoomBy(1);

  void zoomOut() => zoomBy(-1);

  void resetNorth() {
    final current = camera;
    if (current == null) {
      return;
    }
    moveTo(current.copyWith(azimuth: 0, tilt: 0));
  }

  void fitBounds(
    List<AppMapPoint> points, {
    bool animated = true,
  }) {
    final window = _mapWindow;
    final map = window?.map;
    if (window == null || map == null || points.isEmpty) {
      return;
    }
    if (points.length == 1) {
      moveTo(
        AppMapCamera(target: points.first, zoom: 15),
        animated: animated,
      );
      return;
    }

    void applyFit() {
      if (_mapWindow != window) {
        return;
      }
      var minLat = points.first.latitude;
      var maxLat = points.first.latitude;
      var minLon = points.first.longitude;
      var maxLon = points.first.longitude;
      for (final point in points.skip(1)) {
        minLat = minLat < point.latitude ? minLat : point.latitude;
        maxLat = maxLat > point.latitude ? maxLat : point.latitude;
        minLon = minLon < point.longitude ? minLon : point.longitude;
        maxLon = maxLon > point.longitude ? maxLon : point.longitude;
      }

      final box = BoundingBox(
        Point(latitude: minLat, longitude: minLon),
        Point(latitude: maxLat, longitude: maxLon),
      );
      try {
        final position = map.cameraPositionForGeometry(
          Geometry.fromBoundingBox(box),
        );
        map.move(
          position,
          animation: animated
              ? const Animation(type: AnimationType.Smooth, duration: 0.4)
              : const Animation(),
        );
      } catch (_) {
        // Fallback if MapKit is not ready for geometry camera calc.
        moveTo(
          AppMapCamera(
            target: AppMapPoint(
              latitude: (minLat + maxLat) / 2,
              longitude: (minLon + maxLon) / 2,
            ),
            zoom: 12,
          ),
          animated: animated,
        );
      }
    }

    // cameraPositionForGeometry crashes when map size is still 0 (onMapCreated).
    if (window.width() > 0 && window.height() > 0) {
      applyFit();
      return;
    }

    _clearPendingSizeListener();
    late final MapSizeChangedListener listener;
    listener = _MapSizeListener((width, height) {
      if (width <= 0 || height <= 0) {
        return;
      }
      _clearPendingSizeListener();
      applyFit();
    });
    _pendingSizeListener = listener;
    window.addSizeChangedListener(listener);
  }

  void setNightMode(bool enabled) {
    _mapWindow?.map.nightModeEnabled = enabled;
  }

  void setMapStyle(String? style) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }
    if (style == null || style.trim().isEmpty) {
      map.resetMapStyles();
      return;
    }
    map.setMapStyle(style);
  }

  void setTrafficVisible(bool visible) {
    _trafficVisible = visible;
    _trafficLayer?.setTrafficVisible(visible);
    notifyListeners();
  }

  void toggleTraffic() => setTrafficVisible(!_trafficVisible);

  void setUserLocationVisible(bool visible) {
    _userLocationLayer?.setVisible(visible);
  }

  void setMarkers(
    List<AppMapMarker> markers, {
    required bool clustered,
    double clusterRadius = 60,
    int clusterMinZoom = 15,
  }) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }

    _clusterRadius = clusterRadius;
    _clusterMinZoom = clusterMinZoom;

    if (_clusterCollection != null) {
      map.mapObjects.remove(_clusterCollection!);
      _clusterCollection = null;
      _clusterManager = null;
    }
    _markersCollection?.clear();

    if (markers.isEmpty) {
      return;
    }

    if (clustered) {
      _clusterManager = AppMapClusterManager();
      _clusterCollection =
          map.mapObjects.addClusterizedPlacemarkCollection(_clusterManager!);
      for (final marker in markers) {
        final placemark = _clusterCollection!.addPlacemarkWithPoint(
          _toNativePoint(marker.point),
        );
        if (marker.title != null) {
          placemark.setText(marker.title!);
        }
      }
      _clusterCollection!.clusterPlacemarks(
        clusterRadius: _clusterRadius,
        minZoom: _clusterMinZoom,
      );
      return;
    }

    final collection = _markersCollection ??= map.mapObjects.addCollection();
    for (final marker in markers) {
      final placemark = collection.addPlacemarkWithPoint(
        _toNativePoint(marker.point),
      );
      if (marker.title != null) {
        placemark.setText(marker.title!);
      }
    }
  }

  void setPolylines(List<AppMapPolyline> polylines) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }

    for (final existing in _polylines.values) {
      map.mapObjects.remove(existing);
    }
    _polylines.clear();

    for (final polyline in polylines) {
      if (polyline.points.length < 2) {
        continue;
      }
      final object = map.mapObjects.addPolylineWithGeometry(
        Polyline(polyline.points.map(_toNativePoint).toList()),
      );
      object.style = LineStyle(
        strokeWidth: polyline.strokeWidth,
      );
      if (polyline.color != null) {
        object.setStrokeColor(polyline.color!);
      }
      _polylines[polyline.id] = object;
    }
  }

  void setPickPoint(AppMapPoint? point) {
    final map = _mapWindow?.map;
    if (map == null) {
      return;
    }
    if (point == null) {
      if (_pickPlacemark != null) {
        map.mapObjects.remove(_pickPlacemark!);
        _pickPlacemark = null;
      }
      return;
    }
    if (_pickPlacemark == null) {
      _pickPlacemark = map.mapObjects.addPlacemarkWithPoint(
        _toNativePoint(point),
      );
    } else {
      _pickPlacemark!.geometry = _toNativePoint(point);
    }
  }

  /// Снимок через [RepaintBoundary] карты (platform view).
  Future<Uint8List?> takeSnapshot({double pixelRatio = 3}) async {
    final key = snapshotBoundaryKey;
    final context = key?.currentContext;
    if (context == null) {
      return null;
    }
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }
    try {
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  static Point _toNativePoint(AppMapPoint point) {
    return Point(latitude: point.latitude, longitude: point.longitude);
  }

  static CameraPosition _toNativeCamera(AppMapCamera camera) {
    return CameraPosition(
      _toNativePoint(camera.target),
      zoom: camera.zoom,
      azimuth: camera.azimuth,
      tilt: camera.tilt,
    );
  }

  static AppMapCamera _toAppCamera(CameraPosition position) {
    return AppMapCamera(
      target: AppMapPoint(
        latitude: position.target.latitude,
        longitude: position.target.longitude,
      ),
      zoom: position.zoom,
      azimuth: position.azimuth,
      tilt: position.tilt,
    );
  }
}

class _MapTapListener implements MapInputListener {
  _MapTapListener(this._onTap);

  final void Function(AppMapPoint point) _onTap;

  @override
  void onMapTap(mk.Map map, Point point) {
    _onTap(AppMapPoint(latitude: point.latitude, longitude: point.longitude));
  }

  @override
  void onMapLongTap(mk.Map map, Point point) {}
}

class _MapCameraListener implements MapCameraListener {
  _MapCameraListener(this._onChanged);

  final void Function(AppMapCamera camera) _onChanged;

  @override
  void onCameraPositionChanged(
    mk.Map map,
    CameraPosition cameraPosition,
    CameraUpdateReason reason,
    bool finished,
  ) {
    if (!finished) {
      return;
    }
    _onChanged(
      AppMapCamera(
        target: AppMapPoint(
          latitude: cameraPosition.target.latitude,
          longitude: cameraPosition.target.longitude,
        ),
        zoom: cameraPosition.zoom,
        azimuth: cameraPosition.azimuth,
        tilt: cameraPosition.tilt,
      ),
    );
  }
}

class _MapSizeListener implements MapSizeChangedListener {
  _MapSizeListener(this._onChanged);

  final void Function(int width, int height) _onChanged;

  @override
  void onMapWindowSizeChanged(MapWindow mapWindow, int newWidth, int newHeight) {
    _onChanged(newWidth, newHeight);
  }
}
