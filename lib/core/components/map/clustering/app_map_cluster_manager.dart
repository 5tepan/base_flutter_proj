import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart' hide TextStyle;
import 'package:yandex_maps_mapkit_lite/ui_view.dart';

/// ClusterListener: держит strong ref и рисует число в кластере.
class AppMapClusterManager implements ClusterListener {
  AppMapClusterManager({this.color = Colors.blue});

  final Color color;

  @override
  void onClusterAdded(Cluster cluster) {
    final size = cluster.size;
    cluster.appearance.setView(
      ViewProvider(
        builder: () => _ClusterBadge(count: size, color: color),
      ),
    );
  }
}

class _ClusterBadge extends StatelessWidget {
  const _ClusterBadge({
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
