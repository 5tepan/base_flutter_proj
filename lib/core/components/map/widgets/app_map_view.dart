import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/core/components/map/app_map_bootstrap.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';
import 'package:base_flutter_proj/core/components/map/controller/app_map_controller.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

/// Низкоуровневый виджет карты MapKit.
class AppMapView extends StatefulWidget {
  const AppMapView({
    required this.config,
    super.key,
    this.controller,
    this.gesturesEnabled = true,
    this.onMapReady,
    this.onMapTap,
    this.unavailableTitle = 'Карта недоступна',
    this.unavailableSubtitle,
  });

  final AppMapConfig config;
  final AppMapController? controller;
  final bool gesturesEnabled;
  final VoidCallback? onMapReady;
  final AppMapPointCallback? onMapTap;
  final String unavailableTitle;
  final String? unavailableSubtitle;

  @override
  State<AppMapView> createState() => _AppMapViewState();
}

class _AppMapViewState extends State<AppMapView> with WidgetsBindingObserver {
  late final AppMapController _controller =
      widget.controller ?? AppMapController();
  late final bool _ownsController = widget.controller == null;
  final GlobalKey _snapshotKey = GlobalKey();
  bool _appliedInitial = false;

  @override
  void initState() {
    super.initState();
    _controller.snapshotBoundaryKey = _snapshotKey;
    WidgetsBinding.instance.addObserver(this);
    AppMapBootstrap.notifyMapViewStarted();
  }

  @override
  void didUpdateWidget(covariant AppMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.isReady) {
      _applyConfig(widget.config, forceCamera: false);
      _controller.setGesturesEnabled(widget.gesturesEnabled);
      _controller.onMapTap = widget.onMapTap;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppMapBootstrap.notifyMapViewStopped();
    _controller.detach();
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppMapBootstrap.onAppResumed();
    } else {
      AppMapBootstrap.onAppPaused();
    }
  }

  void _onMapCreated(MapWindow mapWindow) {
    _controller.attach(mapWindow);
    _controller.snapshotBoundaryKey = _snapshotKey;
    _controller.onMapTap = widget.onMapTap;
    _controller.setGesturesEnabled(widget.gesturesEnabled);
    _applyConfig(widget.config, forceCamera: true);
    _appliedInitial = true;
    widget.onMapReady?.call();
  }

  void _applyConfig(AppMapConfig config, {required bool forceCamera}) {
    final nightMode =
        config.nightMode ?? Theme.of(context).brightness == Brightness.dark;
    _controller.setNightMode(nightMode);
    _controller.setMapStyle(config.mapStyle);
    _controller.setUserLocationVisible(config.showUserLocation);
    _controller.setMarkers(
      config.markers,
      clustered: config.enableClustering,
      clusterRadius: config.clusterRadius,
      clusterMinZoom: config.clusterMinZoom,
    );
    _controller.setPolylines(config.polylines);

    if (forceCamera || !_appliedInitial) {
      _controller.moveTo(config.initialCamera, animated: false);
      if (config.fitMarkersOnOpen && config.markers.isNotEmpty) {
        _controller.fitBounds(
          config.markers.map((m) => m.point).toList(),
          animated: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AppPlatform.isMobile) {
      return EmptyStateWidget(
        title: widget.unavailableTitle,
        subtitle: widget.unavailableSubtitle ??
            'Карты доступны только на iOS и Android',
        icon: AppAssets.map,
      );
    }

    if (!AppMapBootstrap.isInitialized) {
      return EmptyStateWidget(
        title: widget.unavailableTitle,
        subtitle: widget.unavailableSubtitle ??
            'Укажите MAPKIT_API_KEY в env/*.env.json',
        icon: AppAssets.map,
      );
    }

    return RepaintBoundary(
      key: _snapshotKey,
      child: YandexMap(onMapCreated: _onMapCreated),
    );
  }
}
