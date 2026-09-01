import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';
import 'package:base_flutter_proj/core/components/map/controller/app_map_controller.dart';
import 'package:base_flutter_proj/core/components/map/location/app_map_location_service.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/widgets/app_map_controls.dart';
import 'package:base_flutter_proj/core/components/map/widgets/app_map_view.dart';
import 'package:flutter/material.dart';

/// Полноэкранный экран карты с controls и overlays.
class AppMapPage extends StatefulWidget {
  const AppMapPage({
    required this.config,
    super.key,
    this.controller,
    this.locationService = const AppMapLocationService(),
    this.overlays = const [],
    this.onMapReady,
  });

  final AppMapConfig config;
  final AppMapController? controller;
  final AppMapLocationService locationService;
  final List<Widget> overlays;
  final VoidCallback? onMapReady;

  @override
  State<AppMapPage> createState() => _AppMapPageState();
}

class _AppMapPageState extends State<AppMapPage> {
  late final AppMapController _controller =
      widget.controller ?? AppMapController();
  late final bool _ownsController = widget.controller == null;
  bool _locating = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onMapReady() async {
    widget.onMapReady?.call();
    if (widget.config.autoLocateOnOpen) {
      await _moveToMyLocation(silent: true);
    }
  }

  Future<void> _moveToMyLocation({bool silent = false}) async {
    if (_locating) {
      return;
    }
    setState(() {
      _locating = true;
      if (!silent) {
        _statusMessage = null;
      }
    });

    final result = await widget.locationService.getCurrentPosition();
    if (!mounted) {
      return;
    }

    setState(() => _locating = false);

    switch (result) {
      case AppMapLocationSuccess(:final point):
        _controller.setUserLocationVisible(true);
        _controller.moveTo(AppMapCamera(target: point, zoom: 15));
      case AppMapLocationDenied(:final permanently):
        setState(() {
          _statusMessage = permanently
              ? 'Доступ к геолокации запрещён. Откройте настройки.'
              : 'Нужен доступ к геолокации';
        });
        if (permanently && mounted) {
          final open = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Геолокация'),
              content: const Text(
                'Разрешите доступ к геолокации в настройках приложения.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Настройки'),
                ),
              ],
            ),
          );
          if (open == true) {
            await widget.locationService.openAppSettings();
          }
        }
      case AppMapLocationServiceDisabled():
        setState(() {
          _statusMessage = 'Включите службы геолокации на устройстве';
        });
      case AppMapLocationUnavailable(:final message):
        setState(() {
          _statusMessage = message ?? 'Не удалось определить местоположение';
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: config.title ?? 'Карта',
      ),
      bodyConfig: const AppPageBodyConfig(padding: ScreenContentInsets.zero),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AppMapView(
            config: config,
            controller: _controller,
            onMapReady: _onMapReady,
          ),
          if (config.showControls)
            SafeArea(
              child: AppMapControls(
                controller: _controller,
                showZoom: config.showZoomControls,
                showMyLocation: config.showMyLocationButton,
                showCompass: config.showCompass,
                showTraffic: config.showTrafficToggle,
                trafficVisible: _controller.trafficVisible,
                onMyLocation: _moveToMyLocation,
              ),
            ),
          if (_locating)
            const Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Определение местоположения…'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_statusMessage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(_statusMessage!)),
                          IconButton(
                            icon: const AppIcon(AppAssets.close, size: 18),
                            onPressed: () =>
                                setState(() => _statusMessage = null),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ...widget.overlays,
        ],
      ),
    );
  }
}
