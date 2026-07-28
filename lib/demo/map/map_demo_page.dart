import 'dart:typed_data';

import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/map/map.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Демо модуля карт: preview, fullscreen, pick, cluster, polyline, snapshot.
class MapDemoPage extends StatefulWidget {
  const MapDemoPage({super.key});

  @override
  State<MapDemoPage> createState() => _MapDemoPageState();
}

class _MapDemoPageState extends State<MapDemoPage> {
  static const _demoMarkers = [
    AppMapMarker(
      id: '1',
      point: AppMapPoint(latitude: 55.7539, longitude: 37.6208),
      title: 'Красная площадь',
    ),
    AppMapMarker(
      id: '2',
      point: AppMapPoint(latitude: 55.7601, longitude: 37.6187),
      title: 'ГУМ',
    ),
    AppMapMarker(
      id: '3',
      point: AppMapPoint(latitude: 55.7494, longitude: 37.6122),
      title: 'Храм Христа Спасителя',
    ),
    AppMapMarker(
      id: '4',
      point: AppMapPoint(latitude: 55.7558, longitude: 37.6173),
      title: 'Манеж',
    ),
    AppMapMarker(
      id: '5',
      point: AppMapPoint(latitude: 55.7517, longitude: 37.6007),
      title: 'Арбат',
    ),
    AppMapMarker(
      id: '6',
      point: AppMapPoint(latitude: 55.7644, longitude: 37.6051),
      title: 'Тверская',
    ),
  ];

  static final _demoPolyline = AppMapPolyline(
    id: 'route',
    points: const [
      AppMapPoint(latitude: 55.7539, longitude: 37.6208),
      AppMapPoint(latitude: 55.7558, longitude: 37.6173),
      AppMapPoint(latitude: 55.7517, longitude: 37.6007),
    ],
    color: AppColors.primaryColor,
    strokeWidth: 5,
  );

  AppMapPoint? _pickedPoint;
  final AppMapController _snapshotController = AppMapController();

  AppMapConfig get _baseMapConfig => AppMapConfig(
        title: 'Карта',
        markers: _demoMarkers.take(3).toList(),
        fitMarkersOnOpen: true,
        autoLocateOnOpen: false,
        showUserLocation: true,
      );

  AppMapConfig get _clusterConfig => AppMapConfig(
        title: 'Кластеры',
        markers: _demoMarkers,
        enableClustering: true,
        fitMarkersOnOpen: true,
        showTrafficToggle: true,
      );

  AppMapConfig get _polylineConfig => AppMapConfig(
        title: 'Полилиния',
        markers: _demoMarkers.take(3).toList(),
        polylines: [_demoPolyline],
        fitMarkersOnOpen: true,
      );

  void _openFullscreen(BuildContext context, AppMapConfig config) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppMapPage(config: config),
      ),
    );
  }

  Future<void> _openPick(BuildContext context) async {
    final point = await Navigator.of(context).push<AppMapPoint>(
      MaterialPageRoute(
        builder: (_) => const AppMapPickPage(
          config: AppMapPickConfig(
            title: 'Выбор точки',
            autoLocateOnOpen: true,
          ),
        ),
      ),
    );
    if (!mounted || point == null) {
      return;
    }
    setState(() => _pickedPoint = point);
  }

  Future<void> _openSnapshotDemo(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _SnapshotMapPage(controller: _snapshotController),
      ),
    );
  }

  @override
  void dispose() {
    _snapshotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: l10n.demoMapTitle),
      body: ListView(
        children: [
          Text(
            l10n.demoMapSubtitle,
            style: AppTextStyle.body.copyWith(color: AppColors.darkGrey),
          ),
          const SizedBox(height: 16),
          Text(l10n.demoMapPreviewTitle, style: AppTextStyle.title),
          const SizedBox(height: 8),
          AppMapPreview(
            config: AppMapPreviewConfig(
              map: _baseMapConfig,
              height: 180,
              interactive: false,
            ),
            onOpenFullscreen: _openFullscreen,
          ),
          const SizedBox(height: 12),
          AppMapPreview(
            config: AppMapPreviewConfig(
              map: _baseMapConfig,
              height: 180,
              interactive: true,
              openFullscreenOnTap: true,
            ),
            onOpenFullscreen: _openFullscreen,
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.map_outlined),
            title: Text(l10n.demoMapFullscreenTitle),
            subtitle: Text(l10n.demoMapFullscreenSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openFullscreen(
              context,
              _baseMapConfig.copyWith(autoLocateOnOpen: true),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.place_outlined),
            title: Text(l10n.demoMapPickTitle),
            subtitle: Text(
              _pickedPoint == null
                  ? l10n.demoMapPickSubtitle
                  : '${_pickedPoint!.latitude.toStringAsFixed(5)}, '
                      '${_pickedPoint!.longitude.toStringAsFixed(5)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPick(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bubble_chart_outlined),
            title: Text(l10n.demoMapClusterTitle),
            subtitle: Text(l10n.demoMapClusterSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openFullscreen(context, _clusterConfig),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.route_outlined),
            title: Text(l10n.demoMapPolylineTitle),
            subtitle: Text(l10n.demoMapPolylineSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openFullscreen(context, _polylineConfig),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(l10n.demoMapSnapshotTitle),
            subtitle: Text(l10n.demoMapSnapshotSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openSnapshotDemo(context),
          ),
        ],
      ),
    );
  }
}

class _SnapshotMapPage extends StatefulWidget {
  const _SnapshotMapPage({required this.controller});

  final AppMapController controller;

  @override
  State<_SnapshotMapPage> createState() => _SnapshotMapPageState();
}

class _SnapshotMapPageState extends State<_SnapshotMapPage> {
  bool _busy = false;

  Future<void> _shareSnapshot() async {
    setState(() => _busy = true);
    final bytes = await widget.controller.takeSnapshot();
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    if (bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось сделать снимок')),
      );
      return;
    }
    await AppShare.shareXFiles(
      files: [
        XFile.fromData(
          Uint8List.fromList(bytes),
          mimeType: 'image/png',
          name: 'map_snapshot.png',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppMapPage(
      controller: widget.controller,
      config: const AppMapConfig(
        title: 'Снимок карты',
        markers: [
          AppMapMarker(
            id: '1',
            point: AppMapPoint(latitude: 55.7539, longitude: 37.6208),
          ),
        ],
        fitMarkersOnOpen: true,
      ),
      overlays: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
              child: FilledButton.icon(
                onPressed: _busy ? null : _shareSnapshot,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share),
                label: const Text('Снимок и шаринг'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
