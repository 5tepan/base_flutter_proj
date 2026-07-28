import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_marker.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_polyline.dart';
import 'package:flutter/material.dart';

/// Конфигурация fullscreen / embedded карты.
class AppMapConfig {
  const AppMapConfig({
    this.initialCamera = AppMapCamera.moscow,
    this.markers = const [],
    this.polylines = const [],
    this.showControls = true,
    this.showZoomControls = true,
    this.showMyLocationButton = true,
    this.showCompass = true,
    this.showTrafficToggle = true,
    this.autoLocateOnOpen = false,
    this.showUserLocation = true,
    this.enableClustering = false,
    this.clusterRadius = 60,
    this.clusterMinZoom = 15,
    this.fitMarkersOnOpen = false,
    this.nightMode,
    this.mapStyle,
    this.title,
  });

  final AppMapCamera initialCamera;
  final List<AppMapMarker> markers;
  final List<AppMapPolyline> polylines;
  final bool showControls;
  final bool showZoomControls;
  final bool showMyLocationButton;
  final bool showCompass;
  final bool showTrafficToggle;
  final bool autoLocateOnOpen;
  final bool showUserLocation;
  final bool enableClustering;
  final double clusterRadius;
  final int clusterMinZoom;
  final bool fitMarkersOnOpen;

  /// `null` — брать из [Theme.of(context).brightness].
  final bool? nightMode;

  /// JSON-стиль MapKit (`setMapStyle`). Пустой / null — сброс.
  final String? mapStyle;

  final String? title;

  AppMapConfig copyWith({
    AppMapCamera? initialCamera,
    List<AppMapMarker>? markers,
    List<AppMapPolyline>? polylines,
    bool? showControls,
    bool? showZoomControls,
    bool? showMyLocationButton,
    bool? showCompass,
    bool? showTrafficToggle,
    bool? autoLocateOnOpen,
    bool? showUserLocation,
    bool? enableClustering,
    double? clusterRadius,
    int? clusterMinZoom,
    bool? fitMarkersOnOpen,
    bool? nightMode,
    String? mapStyle,
    String? title,
  }) {
    return AppMapConfig(
      initialCamera: initialCamera ?? this.initialCamera,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      showControls: showControls ?? this.showControls,
      showZoomControls: showZoomControls ?? this.showZoomControls,
      showMyLocationButton: showMyLocationButton ?? this.showMyLocationButton,
      showCompass: showCompass ?? this.showCompass,
      showTrafficToggle: showTrafficToggle ?? this.showTrafficToggle,
      autoLocateOnOpen: autoLocateOnOpen ?? this.autoLocateOnOpen,
      showUserLocation: showUserLocation ?? this.showUserLocation,
      enableClustering: enableClustering ?? this.enableClustering,
      clusterRadius: clusterRadius ?? this.clusterRadius,
      clusterMinZoom: clusterMinZoom ?? this.clusterMinZoom,
      fitMarkersOnOpen: fitMarkersOnOpen ?? this.fitMarkersOnOpen,
      nightMode: nightMode ?? this.nightMode,
      mapStyle: mapStyle ?? this.mapStyle,
      title: title ?? this.title,
    );
  }
}

/// Колбэк открытия fullscreen-карты из preview (без go_router в core).
typedef AppMapOpenFullscreen = void Function(
  BuildContext context,
  AppMapConfig config,
);
