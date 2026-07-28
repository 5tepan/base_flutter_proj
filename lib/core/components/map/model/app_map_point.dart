/// Географическая точка на карте.
class AppMapPoint {
  const AppMapPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppMapPoint &&
            latitude == other.latitude &&
            longitude == other.longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
