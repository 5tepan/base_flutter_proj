import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';
import 'package:base_flutter_proj/core/components/map/controller/app_map_controller.dart';
import 'package:flutter/material.dart';

class AppMapView extends StatelessWidget {
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
  Widget build(BuildContext context) => EmptyStateWidget(
    title: unavailableTitle,
    subtitle: unavailableSubtitle ?? 'Карты доступны в мобильном приложении',
    icon: AppAssets.map,
  );
}
