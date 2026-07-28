import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_pick_config.dart';
import 'package:base_flutter_proj/core/components/map/controller/app_map_controller.dart';
import 'package:base_flutter_proj/core/components/map/location/app_map_location_service.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';
import 'package:base_flutter_proj/core/components/map/widgets/app_map_controls.dart';
import 'package:base_flutter_proj/core/components/map/widgets/app_map_view.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Экран выбора точки на карте. Возвращает [AppMapPoint] через Navigator.pop.
class AppMapPickPage extends StatefulWidget {
  const AppMapPickPage({
    required this.config,
    super.key,
    this.locationService = const AppMapLocationService(),
  });

  final AppMapPickConfig config;
  final AppMapLocationService locationService;

  @override
  State<AppMapPickPage> createState() => _AppMapPickPageState();
}

class _AppMapPickPageState extends State<AppMapPickPage> {
  final AppMapController _controller = AppMapController();
  late AppMapPoint? _selected = widget.config.initialPoint;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onMapReady() async {
    if (_selected != null) {
      _controller.setPickPoint(_selected);
      _controller.moveTo(
        AppMapCamera(target: _selected!, zoom: 15),
        animated: false,
      );
    }
    if (!widget.config.autoLocateOnOpen || _selected != null) {
      return;
    }
    final result = await widget.locationService.getCurrentPosition();
    if (!mounted) {
      return;
    }
    if (result is AppMapLocationSuccess) {
      setState(() => _selected = result.point);
      _controller.setPickPoint(result.point);
      _controller.setUserLocationVisible(true);
      _controller.moveTo(AppMapCamera(target: result.point, zoom: 15));
    }
  }

  void _onMapTap(AppMapPoint point) {
    setState(() => _selected = point);
    _controller.setPickPoint(point);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: config.title ?? 'Выбор точки',
      ),
      bodyConfig: const AppPageBodyConfig(padding: ScreenContentInsets.zero),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AppMapView(
            config: AppMapConfig(
              initialCamera: config.initialCamera,
              showControls: false,
              showUserLocation: true,
            ),
            controller: _controller,
            onMapReady: _onMapReady,
            onMapTap: _onMapTap,
          ),
          SafeArea(
            child: AppMapControls(
              controller: _controller,
              showTraffic: false,
              onMyLocation: () async {
                final result =
                    await widget.locationService.getCurrentPosition();
                if (!mounted) {
                  return;
                }
                if (result is AppMapLocationSuccess) {
                  setState(() => _selected = result.point);
                  _controller.setPickPoint(result.point);
                  _controller.setUserLocationVisible(true);
                  _controller.moveTo(
                    AppMapCamera(target: result.point, zoom: 15),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selected != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surface,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              '${_selected!.latitude.toStringAsFixed(5)}, '
                              '${_selected!.longitude.toStringAsFixed(5)}',
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _selected == null
                            ? null
                            : () => Navigator.of(context).pop(_selected),
                        child: Text(config.confirmLabel ?? 'Выбрать'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
